import { v4 as uuidv4 } from 'uuid';

// Replace authorizationKey with your client-side SDK key.
const config = {
    core: {
      authorizationKey: process.env.REACT_APP_SPLIT_SDK_KEY,
      key: uuidv4(),
    }
  };
  
  export default config;
  
  // Replace the following with the name of your feature flags
  export const background_color = 'background_color';
  // Other treatments as you add them