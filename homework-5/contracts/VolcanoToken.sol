// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract VolcanoToken is ERC721("Volcano Token", "VOL"), Ownable {

    uint256 public tokenId;

    struct TokenData {
        uint256 timestamp;
        uint256 tokenId;
        string tokenURI;
    }

    mapping(address => TokenData[]) public tokens;
    event tokenIdChange(uint256);

    function getTokens(address _account) public view returns (TokenData[] memory) {
        return tokens[_account];
    }

    function removeTokenData(uint256 _tokenId) internal {
        address owner = ownerOf(_tokenId);
        for (uint256 i=0; i < tokens[owner].length; i++) {
            if (tokens[owner][i].tokenId == _tokenId) {
                tokens[owner][i] = tokens[owner][tokens[owner].length-1];
                tokens[owner].pop();
                break;
            }
        }
    }

    function mint() public {
        _safeMint(msg.sender, tokenId);

        string memory baseURI = "Token ID: ";
        TokenData memory newTokenData = TokenData(block.timestamp, tokenId, string(abi.encodePacked(baseURI, Strings.toString(tokenId))));
        tokens[msg.sender].push(newTokenData);

        tokenId++;
        emit tokenIdChange(tokenId);
    }

    function burn(uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "You must be the owner");
        removeTokenData(_tokenId);
        _burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        _requireMinted(_tokenId);

        address owner = ownerOf(_tokenId);
        return tokens[owner][_tokenId].tokenURI;
    }

}