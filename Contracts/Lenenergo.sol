pragma solidity ^0.4.11;

contract energoAccounts {
 
address public owner;
	
function energoAccounts ()public {
		owner = msg.sender;
	}

	modifier OnlyOwner (){
		require (msg.sender == owner);
		_;
	}


struct Client {
    
	uint name;
	uint date;
	uint time;
	uint kVh;
	uint gen;
	uint sety;
	uint com;
	uint sum;
}


Client [] public tab;

mapping (uint => string) organisations;

function AddOrg(uint inn, string org) public {
      organisations[inn] = org;
} 
function getOrg (uint inn) public returns (string){
return organisations[inn];
}

function addToArray (uint _name, uint _date, uint _time, uint _kVh, uint _gen, uint _sety, uint _com, uint _sum) public OnlyOwner {
tab.push(Client ({name: _name, date: _date, time: _time, kVh: _kVh, gen: _gen, sety: _sety,com: _com, sum: _sum }));
} 

uint public clientsStartDate;
function setClientsStartDate (uint _clientsStartDate) public{
    clientsStartDate = _clientsStartDate;
}

uint public clientsEndDate;
function setClientsEndDate (uint _clientsEndDate) public{
    clientsEndDate = _clientsEndDate;
}

uint public clientsStartTime;
function setClientsStartTime (uint _clientsStartTime) public{
    clientsStartTime = _clientsStartTime;
}

uint public clientsEndTime;
function setClientsEndTime (uint _clientsEndTime) public{
    clientsEndTime = _clientsEndTime;
}

uint public totalkVh;


function calculate (uint clientsName) public {
   
    totalkVh = 0;
        
    for (uint i = 0; i < tab.length; i++) {
  
    require (tab[i].date >= clientsStartDate &&  tab[i].date <= clientsEndDate);
    require (tab[i].time >= clientsStartTime &&  tab[i].time <= clientsEndTime);
    require (tab[i].name == clientsName);
        totalkVh += tab[i].kVh;
    
    
    }
}

}