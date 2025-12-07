import * as functions from "firebase-functions";
import Stripe from "stripe";

const stripe = new Stripe('', {
    apiVersion: '2025-11-17.clover',
});

export const createPaymentIntent = functions.https.onRequest(async (request, response) => {
    if(request.method !== "POST") {
        response.status(405).send("Method Not Allowed");
        return;
    }

    try{
        const {amount, currency, description, customerEmail, customerName, customerPhoneNumber} = request.body;

        if(!amount || !currency) {
            response.status(400).send("Thiếu thông tin amount hoặc currency");
            return;
        }

        console.log("Đang xử lý giao dịch cho:", customerEmail);

        let customerId;
        const existingCustomers = await stripe.customers.list({
            email: customerEmail,
            limit: 1,
        });

        if (existingCustomers.data.length > 0) {
            customerId = existingCustomers.data[0].id;
            console.log("Khách hàng cũ, ID:", customerId);
        } else {
            const newCustomer = await stripe.customers.create({
                email: customerEmail,
                name: customerName,
                phone: customerPhoneNumber,
            });
            customerId = newCustomer.id;
            console.log("Tạo khách hàng mới, ID:", customerId);
        }

        const ephemeralKey = await stripe.ephemeralKeys.create(
            {customer: customerId},
            {apiVersion: '2025-11-17.clover'}
        );

        const paymentIntent = await stripe.paymentIntents.create({
            amount: amount,
            currency: currency,
            customer: customerId,
            receipt_email: customerEmail,
            description: description,
            automatic_payment_methods: {
                enabled: true,
                allow_redirects: 'always'
            },
        });

        response.status(200).json({
            clientSecret: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customerId: customerId,
            paymentIntentId: paymentIntent.id
        });
    } catch (error) {
        console.error("Lỗi khi tạo giao dịch:", error);
        response.status(500).json({ error: "Lỗi máy chủ nội bộ: " + error.message });
    }
});


export const cancelOrder = functions.https.onRequest(async (request, response) => {
    if(request.method !== "POST") {
        response.status(405).send("Method Not Allowed");
        return;
    }

    try{
        const {paymentIntentId} = request.body;

        if(!paymentIntentId) {
            response.status(400).send("Thiếu thông tin paymentIntentId");
            return;
        }

        const canceledPaymentIntent = await stripe.paymentIntents.cancel(paymentIntentId);

        response.status(200).json({
            status: canceledPaymentIntent.status
        });
    } catch (error) {
        response.status(500).json({ error: "Lỗi máy chủ nội bộ" });
    }
});