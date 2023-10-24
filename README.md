# Upgradeable NFTmint Contract

This project features an upgradeable NFTmint contract that allows for seamless upgrades without changing the contract's address. It utilizes OpenZeppelin's upgradeable contracts to achieve this functionality. In this document, we'll walk through the steps to show that the contract is upgradeable, how to make upgrades, and how to deploy them.

## Table of Contents
- [Upgradeable Contract](#upgradeable-contract)
- [Making Upgrades](#making-upgrades)
- [Deployment](#deployment)

## Upgradeable Contract

The `NFTmint` contract is made upgradeable through OpenZeppelin's upgradeable contracts. The key characteristics of an upgradeable contract include:
- The ability to change the contract's logic without changing its address.
- Separation of logic and data storage from proxy behavior.

```
contract NFTmint is ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable, EIP712Upgradeable {
    string private constant SIGNING_DOMAIN = 'Voucher-domain';
    string private constant SIGNATURE_VERSION = '1';
    address public minter;

    function initialize(address _signer) public initializer {
        __ERC721_init("NFTmint", "MTK");
        __EIP712_init(SIGNING_DOMAIN, SIGNATURE_VERSION);
        minter = _signer;
    }
}
```

## Making upgrades
To make upgrades to the NFTmint contract, follow these steps:

1. Modify the contract logic to create a new version (e.g., NFTmintV2) that includes the desired changes

```
    function recover(NFTVoucher calldata voucher) public view returns (address) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
        "NFTVoucher(uint256 tokenId,address owner,string uri,uint256 price)",
        voucher.tokenId,
        voucher.price,
        keccak256(bytes(voucher.uri)),
        voucher.owner
    )));
        address signer = ECDSA.recover(digest, voucher.signature);
        return signer;
    }
```

2. Deploy the new version of the contract to the target network.

3. Use the ProxyAdmin contract to upgrade the proxy to the new implementation:

```
```

The upgrade is completed, and the NFTmint contract now incorporates the changes from the new version (NFTmintV2).

## Deployment

Deployment of the upgradeable contract and its proxy is accomplished using Hardhat. The deployment process involves:

1. Deploying the initial version of the NFTmint contract using the upgrades.deployProxy function.

2. Deploying the proxy contract (e.g., NFTmintProxy) that connects to the upgradeable contract.