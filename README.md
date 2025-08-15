# GovernanceHub 🏛️

[![Stacks](https://img.shields.io/badge/Built%20on-Stacks-black?logo=bitcoin&logoColor=orange)](https://www.stacks.co/)
[![Clarity](https://img.shields.io/badge/Smart%20Contracts-Clarity-purple)](https://clarity-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Tests](https://img.shields.io/badge/Tests-Vitest-green)](https://vitest.dev/)

> **Autonomous Community Decision Engine** - Transforming how decentralized communities make collective decisions through transparent, democratic governance with mathematical precision and community consensus.

## 🌟 Overview

GovernanceHub is a sophisticated decentralized governance protocol built on Stacks that empowers communities to make collective financial decisions through a transparent, democratic ecosystem. The protocol leverages advanced tokenomics, time-weighted governance, and built-in treasury management to ensure fair representation while maintaining democratic principles at scale.

### Key Features

- 🗳️ **Democratic Voting System** - Stake-weighted governance with anti-manipulation mechanisms
- 💰 **Treasury Management** - Automated execution of approved community proposals
- ⏰ **Time-Locked Staking** - Prevents short-term manipulation with lock periods
- 🛡️ **Security-First Design** - Comprehensive error handling and access controls
- 📊 **Transparent Operations** - All decisions and transactions are publicly auditable
- ⚖️ **Fair Representation** - Graduated voting weights based on community stake

## 🚀 Quick Start

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Node.js (v16 or higher)
- npm or yarn

### Installation

```bash
git clone https://github.com/peace-eniola/governance-hub.git
cd governance-hub
npm install
```

### Development

```bash
# Check contract syntax
clarinet check

# Run tests
npm test

# Watch mode for continuous testing
npm run test:watch

# Generate test coverage report
npm run test:report
```

### Deploy

```bash
# Deploy to local devnet
clarinet deployments generate --devnet
clarinet deployments apply --devnet

# Deploy to testnet
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

## 🏗️ Architecture

### Core Components

#### 1. Staking System
- **Minimum Deposit**: 1 STX (configurable)
- **Lock Period**: ~10 days (1,440 blocks)
- **Reward Mechanism**: Time-weighted governance tokens

#### 2. Governance Tokens
- **Supply**: Dynamic based on stakes
- **Voting Power**: 1:1 ratio with staked STX
- **Transferability**: Non-transferable (soulbound)

#### 3. Proposal System
- **Duration**: 1-14 days (configurable)
- **Execution**: Automatic upon approval
- **Threshold**: Simple majority (>50%)

### Smart Contract Functions

#### Administrative Functions
```clarity
(initialize) → Response<bool>
```

#### Staking Functions
```clarity
(deposit (amount uint)) → Response<bool>
(withdraw (amount uint)) → Response<bool>
```

#### Governance Functions
```clarity
(create-proposal (description string) (amount uint) (target principal) (duration uint)) → Response<uint>
(vote (proposal-id uint) (vote-for bool)) → Response<bool>
(execute-proposal (proposal-id uint)) → Response<bool>
```

#### Query Functions
```clarity
(get-balance (account principal)) → Response<uint>
(get-total-supply) → Response<uint>
(get-proposal (proposal-id uint)) → Response<optional>
(get-deposit-info (account principal)) → Response<optional>
(get-vote (proposal-id uint) (voter principal)) → Response<optional>
```

## 🔐 Security Features

### Access Controls
- **Owner-only initialization** - Prevents unauthorized setup
- **Stake-based participation** - Only stakeholders can vote
- **Time-locked withdrawals** - Prevents governance attacks

### Anti-Manipulation Mechanisms
- **Double-voting prevention** - Each address can vote once per proposal
- **Minimum stake requirements** - Prevents spam proposals
- **Proposal expiration** - Automatic cleanup of stale proposals

### Error Handling
Comprehensive error codes for all failure scenarios:
- `u100`: Owner-only functions
- `u103`: Insufficient balance
- `u106`: Proposal not found
- `u108`: Already voted
- `u110`: Locked period active

## 📊 Usage Examples

### 1. Initialize the Contract
```clarity
;; Only contract owner can initialize
(contract-call? .governance-hub initialize)
```

### 2. Stake STX and Earn Governance Tokens
```clarity
;; Deposit 10 STX to earn voting power
(contract-call? .governance-hub deposit u10000000)
```

### 3. Create a Community Proposal
```clarity
;; Propose funding for a community project
(contract-call? .governance-hub create-proposal 
  "Fund community developer grant program"
  u5000000  ;; 5 STX
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
  u1440     ;; 10 days duration
)
```

### 4. Vote on Proposals
```clarity
;; Vote in favor of proposal #1
(contract-call? .governance-hub vote u1 true)
```

### 5. Execute Approved Proposals
```clarity
;; Execute proposal after voting period ends
(contract-call? .governance-hub execute-proposal u1)
```

## 🧪 Testing

The project uses Vitest with Clarinet SDK for comprehensive testing:

```typescript
describe("GovernanceHub Tests", () => {
  it("should allow staking and voting", () => {
    // Comprehensive test suite covering:
    // - Staking mechanisms
    // - Proposal creation
    // - Voting processes
    // - Proposal execution
    // - Edge cases and security
  });
});
```

### Running Tests
```bash
# Run all tests
npm test

# Watch mode for development
npm run test:watch

# Generate coverage report
npm run test:report
```

## 🔧 Configuration

### Environment Variables
- `DEVNET_RPC`: Local development RPC endpoint
- `TESTNET_RPC`: Stacks testnet RPC endpoint
- `MAINNET_RPC`: Stacks mainnet RPC endpoint

### Contract Parameters
```clarity
;; Configurable parameters
minimum-deposit: 1 STX (u1000000 microSTX)
lock-period: 1,440 blocks (~10 days)
minimum-duration: 144 blocks (~1 day)
maximum-duration: 20,160 blocks (~14 days)
```

## 🗺️ Roadmap

### Phase 1: Core Governance ✅
- [x] Basic staking and voting
- [x] Proposal creation and execution
- [x] Security implementations

### Phase 2: Enhanced Features 🚧
- [ ] Delegated voting
- [ ] Multi-sig proposals
- [ ] Quadratic voting options
- [ ] Advanced treasury features

### Phase 3: Ecosystem Integration 📋
- [ ] Cross-chain governance
- [ ] DeFi protocol integration
- [ ] Mobile application
- [ ] Governance analytics dashboard

## 🤝 Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `npm test`
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Stacks Foundation](https://stacks.org/) for the robust blockchain infrastructure
- [Hiro Systems](https://hiro.so/) for Clarinet and development tools
- The Stacks community for feedback and support

## 📞 Support & Contact

- **Documentation**: [Wiki](https://github.com/peace-eniola/governance-hub/wiki)
- **Issues**: [GitHub Issues](https://github.com/peace-eniola/governance-hub/issues)
- **Discussions**: [GitHub Discussions](https://github.com/peace-eniola/governance-hub/discussions)
- **Email**: governance-hub@example.com
- **Discord**: [Community Server](https://discord.gg/governance-hub)

---

<p align="center">
  <strong>Built with ❤️ for the decentralized future</strong><br>
  <em>Empowering communities through transparent governance</em>
</p>

<p align="center">
  <sub>GovernanceHub - Where every voice matters, every vote counts, and every decision is transparent.</sub>
</p>
