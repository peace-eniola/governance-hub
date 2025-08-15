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