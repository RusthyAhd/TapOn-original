//endpoints
const express = require('express'); // Import express for build api
const ServiceProviderController = require('../controllers/ServiceProvider.controller');
const {verifyToken} = require("../middleware/authMiddleware"); // check valid token

const router = express.Router(); // Create a new router

// Define the route for service provider registration
router.post('/registration', ServiceProviderController.serviceregister);// serviceregister method in the serviceProviderController.

router.post('/service-providers/category/location', verifyToken, ServiceProviderController.getServiceProviders);//ensure the user is authenticated also

router.get('/find', verifyToken, ServiceProviderController.findServiceProvideByEmail)

router.post('/login/provider', verifyToken, ServiceProviderController.login)

router.put('/update/provider', verifyToken, ServiceProviderController.updateProvider)

module.exports = router;
//Exports the router object so it can be imported and used in other files