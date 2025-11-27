# foundry-ERC20

🔧 A small Foundry-based project demonstrating ERC-20 token development, deployment scripting, and unit testing using Forge.

This repository contains two simple token implementations and a suite of unit tests that demonstrate common ERC-20 behaviors, edge cases and failure conditions.

---

## Overview

- `OurToken` — a minimal ERC-20 token implemented by inheriting OpenZeppelin's `ERC20` contract. It mints an initial supply to the deployer.
- `ManualToken` — a simple, hand-written token-like contract illustrating core methods such as `name`, `decimals`, `totalSupply`, `balanceOf`, and `transfer` without using OpenZeppelin.

The project uses Foundry (Forge, Anvil, Cast) for building, testing and scripting.

---

## Project structure

- `src/OurToken.sol` — OpenZeppelin-based ERC20 token.
- `src/ManualToken.sol` — simple manual token implementation (for learning purposes).
- `script/DeployOurToken.s.sol` — example deployment script that creates `OurToken` with a preconfigured initial supply.
- `test/OurTokenTest.t.sol` — comprehensive test suite covering standard ERC-20 behaviors, revert-cases and edge cases.

---

## Contracts

### OurToken

- File: `src/OurToken.sol`
- Inherits OpenZeppelin's `ERC20` (v5) and mints a configurable `initialSupply` to the deployer.

Constructor signature:

```
constructor(uint256 initialSupply) ERC20("OurToken", "OTK") { ... }
```

Default deployment in the example script uses `1000 ether` as the initial supply.

### ManualToken

- File: `src/ManualToken.sol`
- Minimal, instructional implementation with a public balances mapping and the most-used token functions implemented manually.
- Note: `ManualToken` doesn't mint tokens on deployment — balances start at zero. It is primarily for demonstration and learning.

---

## Tests (what's covered)

Located in `test/OurTokenTest.t.sol`. The tests exercise and prove the behavior of `OurToken` (an OpenZeppelin ERC-20).

Highlights:

- Setup:
	- Deploys `OurToken` using the `DeployOurToken` script.
	- Transfers `100 ether` to `bob` from the deployer — used as the test subject.

- Basic tests:
	- `testInitialSupply`: Asserts total supply is `1000 ether` (the initial supply provided by the script).
	- `testBobBalance`: Confirms `bob`'s balance after the setup transfer.
	- `testTransfer`: Verifies basic ERC-20 transfer works and results are correct.

- Allowance tests:
	- `testApprove`: Basic approval flow.
	- `testIncreaseDecreaseAllowance`: Simulates increase/decrease by re-approving new allowance values.

- Revert tests (expected failures):
	- `testTransferRevertsOnInsufficientBalance`: Transfers from an address with zero tokens should revert.
	- `testTransferFromRevertsWhenAllowanceTooLow`: `transferFrom` should revert when allowance is insufficient.
	- `testTransferFromRevertsWhenBalanceTooLow`: `transferFrom` should revert if the balance is too low.

- Event tests: (present but commented out)
	- Examples that assert `Transfer` and `Approval` events using `vm.expectEmit` (kept as reference / examples).

- Edge cases:
	- `testZeroTransfer`: Sending 0 tokens should do nothing.
	- `testZeroApprove`: Approving zero is allowed.
	- `testSelfApprove`: You can approve yourself.
	- `testTransferToSelf`: Transferring to yourself shouldn't change your balance.

---

## Quick start — requirements

You need Foundry installed. See the Foundry book for installation: https://book.getfoundry.sh/

On a system with Foundry already installed, basic commands below assume you are at the repository root.

### Build

```bash
forge build
```

### Run tests

```bash
forge test
```

If you'd like to run a specific test or file, you can pass filters via Forge (see `forge test --help`).

### Formatting

```bash
forge fmt
```

### Run the deploy script locally (e.g., with Anvil)

1. Launch Anvil in one terminal:

```bash
anvil
```

2. Run the script using Forge (example):

```bash
forge script script/DeployOurToken.s.sol:DeployOurToken --fork-url http://127.0.0.1:8545 --broadcast
```

The script creates an `OurToken` instance with `1000 ether` initial supply and returns the deployed contract instance.

---

## Notes & tips

- `ManualToken` is intentionally simple and incomplete — it's for learning and comparison against `OurToken`.
- Tests live in `test/` and use `forge-std` utilities (the `vm` cheatcodes) for setting up scenarios and assertions.
- Several tests demonstrate different categories: happy-paths, reverts, and edge cases; they are good examples for learning how to write Foundry tests.

---

## Contributing

If you want to expand this repo, you could:

- Add tests for `ManualToken` to exercise its transfer behavior and to initialize balances.
- Add property-based or fuzz tests to exercise ERC-20 rules more broadly.
- Add deploy scripts for different networks and CI integration.

---

License: see repository headers. This repo demonstrates educational examples for token development with Foundry.

If anything is missing or you'd like the README to mention a specific development workflow (CI, GitHub Actions, or README badges), tell me and I will add that next.
