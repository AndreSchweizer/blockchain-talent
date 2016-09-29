contract Container {
    uint public id;
    string public contentDescription;
    enum State { Initial, LoadingSpecified, Sent, ApprovedForShipping, Loaded, ApprovedForCollecting, Collected  }
    State public currentState;
    address public owner;
    address public forwarder;
    address public party;
    mapping (address => bool) public whitelist;
    bool ownerSet = false;
    event ContainerInitialized(address party, State currentState);
    event ContainerLoadingSpecified(address party, State currentState);
    event ContainerSent(address party, State currentState);
    event ContainerApprovedForShipping(address party, State currentState);
    event ContainerLoaded(address party, State currentState);
    event ContainerApprovedForCollecting(address party, State currentState);
    event ContainerCollected(address party, State currentState);



    modifier isWhitelisted {
        if (whitelist[msg.sender] == false) throw;
        _
    }
    
    function Container(){
        whitelist[msg.sender] = true;
        forwarder = msg.sender;
        currentState = State.Initial;
        ContainerInitialized(msg.sender, currentState);
        
    }
    
    function specifyLoading(uint idEx, string description) isWhitelisted {
        if (currentState != State.Initial) throw;
        id = idEx;
        contentDescription = description;  
        currentState = State.LoadingSpecified;
        ContainerLoadingSpecified(msg.sender, currentState);
    }
    
    function send() isWhitelisted {
        if (currentState != State.LoadingSpecified) throw;
        currentState = State.Sent;
        ContainerSent(msg.sender, currentState);
    }
    
    function approveForShipping() isWhitelisted {
        if (currentState != State.Sent) throw;
        currentState = State.ApprovedForShipping;  
        ContainerApprovedForShipping(msg.sender, currentState);
    }
    
    function load() isWhitelisted {
        if (currentState != State.ApprovedForShipping) throw;
        currentState = State.Loaded;  
        ContainerLoaded(msg.sender, currentState);
    }
    
    function approveForCollecting() isWhitelisted {
        if (currentState != State.Loaded) throw;
        currentState = State.ApprovedForShipping; 
        ContainerApprovedForCollecting(msg.sender, currentState);
    }
    
    function collect() isWhitelisted {
        if (currentState != State.ApprovedForCollecting && msg.sender != owner) throw;
        currentState = State.ApprovedForCollecting; 
        ContainerCollected(msg.sender, currentState);
    }
    
    function addToWhitelist(address party) isWhitelisted {
        whitelist[party] = true;
    }
    
    function removefromWhitelist(address party) isWhitelisted {
        whitelist[party] = false;
    }
    
    function updateOwnership(address newOwner) isWhitelisted {
        if (msg.sender != owner) throw;
        owner = newOwner;   
    }
    
    function setOwner(address newOwner) isWhitelisted {
        if (msg.sender != forwarder && !ownerSet) throw;
        ownerSet = true;
        owner = newOwner;
    }
}
