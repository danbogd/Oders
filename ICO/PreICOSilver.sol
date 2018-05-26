pragma solidity ^0.4.15;

contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}



interface MyToken {
    function transfer (address _receiver, uint256 _tokens) external;
    
}

// Объявляем контракт
contract SilverPreICO is Ownable{

    // Объявляем переменную для стомости токена
    uint public buyPrice;

    // Объявялем переменную для токена
    MyToken public token;
    uint public tokens;
    address multisig;
    uint start;
    uint period;
    uint hardcap;

    // Функция инициализации
    function SilverPreICO(MyToken _token) public{
        // Присваиваем токен
        token = _token;
        multisig = 0xB39DA76Da3c9e2e7421882a93a8546fD26bd5CAB;
        start = 1524873600;// 28.04.2018
      period = 91;
        hardcap = 10000000000000000000000;// 5 000 000 USD
        buyPrice = 100000000; // цена в gwei за одну минимальную долю токена
    }

   function SetPrice (uint _newBuyPrice) public onlyOwner {
       buyPrice = _newBuyPrice;
   }
   
   
   modifier saleIsOn() {
      require(now > start && now < start + period * 1 days);
      _;
    }
  
  
    modifier isUnderHardCap() {
        require(multisig.balance <= hardcap);
        _;
    }
   
   function forwardFunds() internal {
      multisig.transfer(this.balance);
  }
   

   // Вызываемая функция для отправки эфиров на контракт, возвращающая количество купленных токенов
    function () payable {
       _buy(msg.sender, msg.value) ;
    }
    
    
  
  

     // Вызываемая функция для отправки эфиров на контракт, возвращающая количество купленных токенов
    function buy() payable public  isUnderHardCap saleIsOn returns (uint){  //isUnderHardCap saleIsOn
        tokens = _buy(msg.sender, msg.value);
        return tokens;
       
    }
    
    // Внутренняя функция покупки токенов, возвращает число купленных токенов
    function _buy(address _sender,uint _value) internal returns (uint){
        // Рассчитываем стоимость
        tokens = _value / buyPrice;
        // Отправляем токены с помощью вызова метода токена
        token.transfer(_sender, tokens);
        forwardFunds ();
        // Возвращаем значение
        return tokens;
    }
     

    function destruct() public {
        require(msg.sender == owner);
        selfdestruct(msg.sender);
    }
}