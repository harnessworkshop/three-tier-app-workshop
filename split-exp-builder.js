var SplitFactory = require('@splitsoftware/splitio').SplitFactory;
var factory = SplitFactory({
  core: {
    authorizationKey: process.env.SPLIT_SERVER_SDK_KEY
  }
});

var client = factory.client();

client.on(client.Event.SDK_READY, function() {
    populateExperimentData();
})

function populateExperimentData() {
    for(i=0; i<1000; i++) {
        var treatment = client.getTreatment(i, 'background_color');
    
        const randomInt = Math.random();
    
        if (treatment == 'transparent' && randomInt >= 0.6) {
            console.log("randomInt", randomInt, "treatment", treatment, i);
            sendEvent(i).then((event) => { console.log(event)});
        } 
    
        if (treatment == 'blue' && randomInt >= 0.75) {
            console.log("randomInt", randomInt, "treatment", treatment, i);
            sendEvent(i).then((event) => { console.log(event)});
        } 
    
        if (treatment == 'green' && randomInt >= 0.9) {
            console.log("randomInt", randomInt, "treatment", treatment, i);
            sendEvent(i).then((event) => { console.log(event)});
        } 
    
        if (treatment == 'gray' && randomInt >= 0.95) {
            console.log("randomInt", randomInt, "treatment", treatment, i);
            sendEvent(i).then((event) => { console.log(event)});
        } 
    
        if (treatment == 'orange' && randomInt >= 0.98) {
            console.log("randomInt", randomInt, "treatment", treatment, i);
            sendEvent(i).then((event) => { console.log(event)});
        } 
    }
}


function sendEvent(id) {
    const options = {
        method: 'POST',
        headers: {
            'content-type': 'application/json',
            Authorization: 'Bearer ' + process.env.SPLIT_SERVER_SDK_KEY,
        },
        body: JSON.stringify({ 
            eventTypeId: "sign_up", 
            trafficTypeName: "user", 
            key: id,
            environmentName: "staging"
        }),
      };

      return fetch('https://events.split.io/api/events', options)
        .then(response => {
            console.log("succerssful request");
        })
        .then(response => console.log(response))
        .catch(err => console.error(err));    
}
