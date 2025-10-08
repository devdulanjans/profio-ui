const baseUrl = "https://profio-app-lfxvn.ondigitalocean.app";



const postSignUp = "/api/access/signup";
const getAllSubscriptions = "/api/subscriptions";
const postGetPreSignedUrl = "/api/users/presign_url"; // to upload document & images | png,jpeg,jpg
const putUpdateUserDetails = "/api/users";//pass userId
const getUserByUID = "/api/users/uid"; //pass firebase uuid
const getAllTemplatesDetails = "/api/templates";
String postCreateTemplateForUser (String userId,String templateId) =>"/api/user-templates/$userId/$templateId";