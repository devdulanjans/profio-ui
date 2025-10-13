const baseUrl = "https://profio-app-lfxvn.ondigitalocean.app";
const imageBaseUrl = "https://profio-dbcm-s3-dev.sgp1.digitaloceanspaces.com";



String fetchImage (String userId,String type,String url) =>"$imageBaseUrl/$userId/$type/$url"; //type - DOCUMENT | PROFILE
const postSignUp = "/api/access/signup";
const getAllSubscriptions = "/api/subscriptions";
const postGetPreSignedUrl = "/api/users/presign_url"; // to upload document & images | png,jpeg,jpg
const putUpdateUserDetails = "/api/users";//pass userId
const getUserByUID = "/api/users/uid"; //pass firebase uuid
const getAllTemplatesDetails = "/api/templates";
const getUserTemplates = "/api/user-templates";
String postCreateTemplateForUser (String userId,String templateId) =>"/api/user-templates/$userId/$templateId";
const putSubscribeLanguage = "/api/users/language/subscribe";
const postShareTemplate = "/api/user-templates/share";
