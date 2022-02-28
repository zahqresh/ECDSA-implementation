// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.4.0/utils/cryptography/ECDSA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol";

contract MyToken is ERC721 {
    address owner;

    constructor() ERC721("MyToken", "MTK") {
        owner = msg.sender;
    }

    //get the address of the signer
    function getSigner(
        bytes32 message,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (address) {
        require(
            uint256(s) <=
                0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
            "invalid signature 's' value"
        );
        require(v == 27 || v == 28, "invalid signature 'v' value");
        address signer = ecrecover(message, v, r, s);
        require(signer != address(0), "invalid signature");

        return signer;
    }

    //verify that the message hashed and signed is legit and is by owner
    //verify the address returned by function and also verify the message hashed with signature
    //it'll provide layers of security
    //This recreates the message hash that was signed on the client.

    /**
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    function toEthSignedMessageHash(bytes32 hash)
        internal
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    //verify signer is legit
    function verify(
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 amountAllowed,
        uint256 free
    ) public view returns (bool) {
        bytes32 messageHashed = keccak256(
            abi.encodePacked(msg.sender, amountAllowed, free)
        );
        bytes32 hash = toEthSignedMessageHash(messageHashed);
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "invalid signature");

        if (signer == 0xA030ed6d2752a817747a30522B4f3F1b7f039c80) {
            return true;
        } else {
            return false;
        }
    }
}
