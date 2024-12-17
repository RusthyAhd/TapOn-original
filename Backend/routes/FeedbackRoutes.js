const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedback.controler');

// Create a new feedback
router.post('/', feedbackController.createFeedback);

// Get all feedbacks
router.get('/', feedbackController.getAllFeedbacks);

// Get feedback by ID
router.get('/:id', feedbackController.getFeedbackById);

// Update feedback by ID
router.put('/:id', feedbackController.updateFeedbackById);

// Delete feedback by ID
router.delete('/:id', feedbackController.deleteFeedbackById);

module.exports = router;