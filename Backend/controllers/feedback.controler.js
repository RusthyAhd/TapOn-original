const FeedbackModel = require('../models/Feedback.model');

// Create a new feedback
exports.createFeedback = async (req, res) => {
    try {
        const feedback = new FeedbackModel(req.body);
        await feedback.save();
        res.status(201).send(feedback);
    } catch (error) {
        res.status(400).send({ message: error.message });
    }
};

// Get all feedbacks
exports.getAllFeedbacks = async (req, res) => {
    try {
        const feedbacks = await FeedbackModel.find();
        res.status(200).send(feedbacks);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

// Get feedback by ID
exports.getFeedbackById = async (req, res) => {
    try {
        const feedback = await FeedbackModel.findById(req.params.id);
        if (!feedback) {
            return res.status(404).send({ message: 'Feedback not found' });
        }
        res.status(200).send(feedback);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

// Update feedback by ID
exports.updateFeedbackById = async (req, res) => {
    try {
        const feedback = await FeedbackModel.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!feedback) {
            return res.status(404).send({ message: 'Feedback not found' });
        }
        res.status(200).send(feedback);
    } catch (error) {
        res.status(400).send({ message: error.message });
    }
};

// Delete feedback by ID
exports.deleteFeedbackById = async (req, res) => {
    try {
        const feedback = await FeedbackModel.findByIdAndDelete(req.params.id);
        if (!feedback) {
            return res.status(404).send({ message: 'Feedback not found' });
        }
        res.status(200).send({ message: 'Feedback deleted successfully' });
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};