// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract NFTmint is ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable, EIP712Upgradeable {
    string private constant SIGNING_DOMAIN = 'Voucher-domain';
    string private constant SIGNATURE_VERSION = '1';
    address public minter;

    function initialize(address _signer) public initializer {
        __ERC721_init("NFTmint", "MTK");
        __EIP712_init(SIGNING_DOMAIN, SIGNATURE_VERSION);
        minter = _signer;
    }

        struct NFTVoucher {
        uint256 tokenId;
        address owner;
        string uri;
        uint256 price;
        bytes signature;
    }

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

    function safeMint(NFTVoucher calldata voucher)
    public
    payable
    {
        require(owner() == recover(voucher), "NFTmint: invalid signature");
        require(msg.value >= voucher.price, "NFTmint: not enough ether");
        _safeMint(voucher.owner, voucher.tokenId);
        _setTokenURI(voucher.tokenId, voucher.uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}