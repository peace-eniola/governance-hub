;; Title: GovernanceHub - Autonomous Community Decision Engine

;; Summary:
;; GovernanceHub transforms how decentralized communities make collective decisions
;; by creating a transparent, democratic ecosystem where every voice matters and 
;; financial decisions are executed with mathematical precision and community consensus.

;; Description:
;; Built for the next generation of decentralized organizations, GovernanceHub leverages
;; advanced tokenomics and time-weighted governance to ensure fair representation in
;; community funding decisions. Members stake assets to earn voting power, propose
;; initiatives that align with community goals, and participate in a trustless system
;; where approved proposals are automatically executed. The protocol features sophisticated
;; anti-manipulation mechanisms, graduated voting weights, and built-in treasury management
;; tools that scale with your community's growth while maintaining democratic principles.

;; SYSTEM CONSTANTS & ERROR HANDLING

(define-constant contract-owner tx-sender)

;; Error Code Registry
(define-constant err-owner-only (err u100))
(define-constant err-not-initialized (err u101))
(define-constant err-already-initialized (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-unauthorized (err u105))
(define-constant err-proposal-not-found (err u106))
(define-constant err-proposal-expired (err u107))
(define-constant err-already-voted (err u108))
(define-constant err-below-minimum (err u109))
(define-constant err-locked-period (err u110))
(define-constant err-transfer-failed (err u111))
(define-constant err-invalid-duration (err u112))
(define-constant err-zero-amount (err u113))
(define-constant err-invalid-target (err u114))
(define-constant err-invalid-description (err u115))
(define-constant err-invalid-proposal-id (err u116))
(define-constant err-invalid-vote (err u117))

;; Protocol Configuration
(define-constant minimum-duration u144) ;; Minimum proposal duration: 1 day (144 blocks @ 10min)
(define-constant maximum-duration u20160) ;; Maximum proposal duration: 14 days

;; STATE VARIABLES

(define-data-var total-supply uint u0)
(define-data-var minimum-deposit uint u1000000) ;; Minimum stake: 1 STX (in microSTX)
(define-data-var lock-period uint u1440) ;; Stake lock period: ~10 days in blocks
(define-data-var initialized bool false)
(define-data-var last-rebalance uint u0)
(define-data-var proposal-count uint u0)

;; DATA STORAGE MAPS

;; Governance token balances (determines voting weight)
(define-map balances
  principal
  uint
)

;; Stake tracking with time-lock mechanisms
(define-map deposits
  principal
  {
    amount: uint,
    lock-until: uint,
    last-reward-block: uint,
  }
)

;; Comprehensive proposal registry
(define-map proposals
  uint
  {
    proposer: principal,
    description: (string-ascii 256),
    amount: uint,
    target: principal,
    expires-at: uint,
    executed: bool,
    yes-votes: uint,
    no-votes: uint,
  }
)

;; Vote tracking system (prevents double voting)
(define-map votes
  {
    proposal-id: uint,
    voter: principal,
  }
  bool
)

;; INTERNAL UTILITY FUNCTIONS

(define-private (is-contract-owner)
  (is-eq tx-sender contract-owner)
)

(define-private (check-initialized)
  (ok (asserts! (var-get initialized) err-not-initialized))
)

(define-private (validate-proposal-id (proposal-id uint))
  (ok (asserts! (<= proposal-id (var-get proposal-count)) err-invalid-proposal-id))
)

(define-private (calculate-voting-power (voter principal))
  (default-to u0 (map-get? balances voter))
)

(define-private (transfer-tokens
    (sender principal)
    (recipient principal)
    (amount uint)
  )
  (let (
      (sender-balance (default-to u0 (map-get? balances sender)))
      (recipient-balance (default-to u0 (map-get? balances recipient)))
    )
    (asserts! (>= sender-balance amount) err-insufficient-balance)
    (map-set balances sender (- sender-balance amount))
    (map-set balances recipient (+ recipient-balance amount))
    (ok true)
  )
)

(define-private (mint-tokens
    (account principal)
    (amount uint)
  )
  (let ((current-balance (default-to u0 (map-get? balances account))))
    (map-set balances account (+ current-balance amount))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)
  )
)

(define-private (burn-tokens
    (account principal)
    (amount uint)
  )
  (let ((current-balance (default-to u0 (map-get? balances account))))
    (asserts! (>= current-balance amount) err-insufficient-balance)
    (map-set balances account (- current-balance amount))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok true)
  )
)

;; PROTOCOL ADMINISTRATION

(define-public (initialize)
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (not (var-get initialized)) err-already-initialized)
    (var-set initialized true)
    (ok true)
  )
)

;; STAKE & GOVERNANCE TOKEN MANAGEMENT

(define-public (deposit (amount uint))
  (begin
    (try! (check-initialized))
    (asserts! (>= amount (var-get minimum-deposit)) err-below-minimum)
    (asserts! (> amount u0) err-zero-amount)

    ;; Secure STX transfer to governance treasury
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Register stake with lock-up period
    (map-set deposits tx-sender {
      amount: amount,
      lock-until: (+ stacks-block-height (var-get lock-period)),
      last-reward-block: stacks-block-height,
    })

    ;; Issue governance tokens proportional to stake
    (mint-tokens tx-sender amount)
  )
)

(define-public (withdraw (amount uint))
  (begin
    (try! (check-initialized))
    (asserts! (> amount u0) err-zero-amount)

    (let (
        (deposit-info (unwrap! (map-get? deposits tx-sender) err-unauthorized))
        (user-balance (unwrap! (get-balance tx-sender) err-unauthorized))
      )