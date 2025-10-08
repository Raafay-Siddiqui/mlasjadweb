# Stripe Payment Integration Setup Guide

This guide will help you set up Stripe payments for Al-Baqi Academy courses.

## Prerequisites

- A Stripe account (sign up at [stripe.com](https://stripe.com))
- Access to your Stripe Dashboard
- Your application running on a publicly accessible domain (for webhooks)

## Step 1: Get Your Stripe API Keys

1. Go to [Stripe Dashboard](https://dashboard.stripe.com)
2. Click on **Developers** → **API keys**
3. You'll see two types of keys:
   - **Test keys** (for testing): `sk_test_...` and `pk_test_...`
   - **Live keys** (for production): `sk_live_...` and `pk_live_...`

4. Start with **test mode** keys for development

## Step 2: Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit your `.env` file and add your Stripe keys:
   ```bash
   STRIPE_SECRET_KEY=sk_test_51ABC...xyz
   STRIPE_PUBLISHABLE_KEY=pk_test_51ABC...xyz
   ```

## Step 3: Set Up Stripe Webhook

Webhooks allow Stripe to notify your application when a payment is completed.

### Local Development (using Stripe CLI)

1. Install Stripe CLI:
   ```bash
   # On macOS
   brew install stripe/stripe-cli/stripe

   # On other systems, visit: https://stripe.com/docs/stripe-cli
   ```

2. Login to Stripe CLI:
   ```bash
   stripe login
   ```

3. Forward webhook events to your local server:
   ```bash
   stripe listen --forward-to localhost:5005/stripe/webhook
   ```

4. Copy the webhook signing secret (starts with `whsec_...`) and add it to your `.env`:
   ```bash
   STRIPE_WEBHOOK_SECRET=whsec_abc123...
   ```

### Production (using Stripe Dashboard)

1. Go to [Stripe Dashboard](https://dashboard.stripe.com) → **Developers** → **Webhooks**
2. Click **Add endpoint**
3. Enter your webhook URL: `https://yourdomain.com/stripe/webhook`
4. Select events to listen for:
   - ✅ `checkout.session.completed`
5. Click **Add endpoint**
6. Copy the **Signing secret** and add it to your production `.env` file

## Step 4: Set Course Pricing

1. Login to your admin panel
2. Go to **Manage Courses**
3. Edit a course and set a price (e.g., `29.99`)
4. Save the course
5. Click **🔄 Sync with Stripe** button to create the product in Stripe

## Step 5: Testing Payments

### Test Card Numbers

Use these test card numbers in Stripe test mode:

| Card Number         | Result                    |
|---------------------|---------------------------|
| 4242 4242 4242 4242 | Successful payment        |
| 4000 0000 0000 0002 | Card declined             |
| 4000 0025 0000 3155 | Requires authentication   |

- **Expiry**: Any future date (e.g., 12/34)
- **CVC**: Any 3 digits (e.g., 123)
- **ZIP**: Any 5 digits (e.g., 12345)

### Testing the Flow

1. **Browse to homepage** and find a paid course
2. **Click "Purchase Course"** (you'll be redirected to Stripe Checkout)
3. **Enter test card details** (e.g., 4242 4242 4242 4242)
4. **Complete the payment**
5. **Verify access**: You should be redirected to the success page and have access to the course

## Step 6: Verify Integration

### Check Stripe Dashboard

1. Go to [Stripe Dashboard](https://dashboard.stripe.com) → **Payments**
2. You should see your test payment
3. Click on the payment to see details

### Check Database

1. Check the `course_access` table in your database:
   ```sql
   SELECT * FROM course_access WHERE access_type = 'purchased';
   ```
2. You should see a record with:
   - `user_id`: The user who purchased
   - `course_id`: The purchased course
   - `stripe_payment_intent_id`: Stripe payment reference
   - `amount_paid`: The amount paid

### Test Course Access

1. Login with the user who made the purchase
2. Go to "My Courses"
3. The purchased course should show "✅ Enrolled" or "Continue Learning"
4. You should be able to access all course materials

## Step 7: Going Live

When ready for production:

1. **Switch to live mode** in Stripe Dashboard
2. Get your **live API keys**: `sk_live_...` and `pk_live_...`
3. Update your production `.env` file with live keys
4. **Create production webhook**:
   - URL: `https://yourdomain.com/stripe/webhook`
   - Event: `checkout.session.completed`
   - Get the signing secret and update `.env`
5. **Test with real card** (use a small amount first!)
6. **Monitor payments** in Stripe Dashboard

## Currency Settings

By default, the integration uses **GBP (£)**. To change the currency:

1. Edit `stripe_helpers.py`
2. Find the line: `currency='gbp'`
3. Change to your preferred currency code:
   - `'usd'` for US Dollars
   - `'eur'` for Euros
   - `'cad'` for Canadian Dollars
   - etc.

## Security Best Practices

✅ **DO:**
- Keep your Stripe secret key confidential
- Use webhook signature verification (already implemented)
- Use HTTPS in production
- Monitor Stripe Dashboard for suspicious activity
- Test thoroughly in test mode before going live

❌ **DON'T:**
- Commit `.env` file to version control
- Share your secret keys publicly
- Skip webhook verification
- Grant course access without webhook confirmation

## Troubleshooting

### "Payment system error"
- Check that your Stripe keys are correct in `.env`
- Verify the course has been synced with Stripe (click "🔄 Sync with Stripe")
- Check application logs for detailed error messages

### "Webhook signature verification failed"
- Ensure `STRIPE_WEBHOOK_SECRET` is set correctly
- In local development, make sure Stripe CLI is running
- In production, verify the webhook endpoint URL is correct

### Course access not granted after payment
- Check webhook is configured and receiving events
- View Stripe Dashboard → Webhooks → Events to see if webhook was called
- Check application logs for webhook processing errors
- Verify the webhook endpoint is publicly accessible (not behind authentication)

## Support

For Stripe-specific issues:
- [Stripe Documentation](https://stripe.com/docs)
- [Stripe Support](https://support.stripe.com/)

For application-specific issues:
- Check application logs
- Review the webhook event details in Stripe Dashboard
- Contact your development team

## Features Implemented

✅ One-time course payments
✅ Secure Stripe Checkout
✅ Webhook-based access granting
✅ Admin Stripe sync
✅ Test mode support
✅ Payment success/cancel pages
✅ Course pricing display
✅ Access control based on payment

## Future Enhancements

Some ideas for future improvements:
- Subscription-based access (monthly/yearly)
- Coupon codes and discounts
- Bundle pricing (buy multiple courses)
- Payment plans (installments)
- Refund management
- Revenue reporting dashboard
