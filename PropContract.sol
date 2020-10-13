pragma solidity ^0.5.11;

contract PropContractProject
{
    //This contract is to transfer ownership of property from a seller to a buyer
    
    uint public totalLandsCounter;  // count number of properties
    address public owner; // address of owner
    
    enum Status{
        Pending, //0
        Sold //1
    }
    
    struct Land
    {
    address ethaddress;
    uint value;
    uint landID;
    Status status;
    }
    
    mapping (address => Land[]) public __ownedLands;
    
    constructor() public
    {
        totalLandsCounter = 0;
        owner = msg.sender;
    }
    
    // modifier to access control
    modifier isOwner
    {
        require(msg.sender == owner);
        _;
    }
    
    event Add(address _owner, uint _landID);
    
    //Add properties
    function addProperty(address propertyOwner, uint _value) public isOwner
    {
        totalLandsCounter ++;
        Land memory  myLand = Land({
            ethaddress: propertyOwner,
            value : _value,
            landID :totalLandsCounter,
            status : Status.Pending
        });
        __ownedLands[propertyOwner].push(myLand);
        emit Add(propertyOwner, totalLandsCounter);
    }
    
    //Buy properties
    function changeOwnership(uint _landId, address _buyer) public isOwner
    {
        require(msg.sender != _buyer);
        for(uint i = 0; i< __ownedLands[msg.sender].length; i++)
        {
            if(__ownedLands[msg.sender][i].status == Status.Pending && __ownedLands[msg.sender][i].landID == _landId)
            {
                (__ownedLands[msg.sender][i].ethaddress == _buyer, __ownedLands[msg.sender][i].status == Status.Sold);
            }
        }
    }
    
    //Get unsold properties
    function unsoldProperty(address _ethaddress) public view returns (uint,uint) 
    {
        for(uint i = 0; i< __ownedLands[_ethaddress].length; i++)
        {
            if(__ownedLands[_ethaddress][i].status == Status.Pending)
            {
                return (__ownedLands[_ethaddress][i].value, __ownedLands[_ethaddress][i].landID);
            }
        }
    }
    
    //Get property details using ID and address
    function getProperty(uint _landId, address _ethaddress) public view returns (Status, uint, address) {
        for(uint i = 0; i< __ownedLands[_ethaddress].length; i++)
        {
            if(__ownedLands[_ethaddress][i].landID == _landId)
            {
                return (__ownedLands[_ethaddress][i].status, __ownedLands[_ethaddress][i].value, __ownedLands[_ethaddress][i].ethaddress);
            }
        }
    }

    //Edit property details
    function editProperty(uint _landId, uint _newValue) public  
    {
        for(uint i = 0; i< __ownedLands[msg.sender].length; i++)
        {
            if(__ownedLands[msg.sender][i].landID == _landId)
            {
                __ownedLands[msg.sender][i].value == _newValue;
            }
        }
    
    }
    
}
