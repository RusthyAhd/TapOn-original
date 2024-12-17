const mongoose = require('mongoose');


const serviceSchema = new mongoose.Schema({
    service_id: { type: String, required: true, unique: true },
    service_name: { type: String, required: true }, 
    provider_name: { type: String, required: true }, 
    description: { type: String, required: true },
    service_provider_id: { type: String, required: true },
    service_category: { type: String, required: true },
    picture_url: { type: String, required: true }, 
    price: { type: Number, required: true },
    availability: { 
        type: String,
        enum: ['Available', 'Unavailable'],
        required: true 
    },
    available_days: { type: [String], required: true },
    available_hours: { type: String, required: true },
    condition: { type: String, required: true },
    location_long: { type: Number, required: true },
    location_lat: { type: Number, required: true },
}, { timestamps: true });


const Service = mongoose.models.Service || mongoose.model('Service', serviceSchema);

module.exports = Service;
