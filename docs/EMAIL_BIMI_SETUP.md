# Email Logo & BIMI Setup Guide

## Current Status
✅ **Logo Embedding**: Emails now include the Al-Baqi Academy logo as base64-encoded inline image
✅ **Email Headers**: Added proper sender name and organization headers
⏳ **BIMI**: Requires DNS records and domain verification (setup instructions below)

## What Was Fixed

### 1. Logo Display in Emails
The logo now embeds directly in emails using base64 encoding, so it displays immediately without requiring external image hosting. This works in all email clients.

### 2. Sender Information
Emails now show:
- **From**: Al-Baqi Academy <noreply@albaqiacademy.com>
- **Organization**: Al-Baqi Academy
- Proper email headers for deliverability

---

## BIMI (Brand Indicators for Message Identification)

BIMI allows your logo to appear next to your emails in Gmail, Yahoo, and other email clients. To enable BIMI, you need to complete these steps:

### Step 1: Email Authentication (Required for BIMI)

You must have **all three** authentication methods set up:

#### A. SPF Record (Sender Policy Framework)
Add this TXT record to your DNS for `albaqiacademy.com`:

```
Name: @
Type: TXT
Value: v=spf1 include:kundenserver.de ~all
```

**Explanation**: This tells email servers that emails from your domain can come from IONOS servers.

#### B. DKIM Record (DomainKeys Identified Mail)
IONOS should provide you with a DKIM key. If not, generate one in your IONOS email settings.

Typical DKIM record:
```
Name: default._domainkey
Type: TXT
Value: v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY_HERE
```

**To get your DKIM key**:
1. Log in to IONOS control panel
2. Go to Email → Settings → DKIM
3. Enable DKIM and copy the record
4. Add it to your DNS

#### C. DMARC Record (Domain-based Message Authentication)
Add this TXT record:

```
Name: _dmarc
Type: TXT
Value: v=DMARC1; p=quarantine; rua=mailto:dmarc@albaqiacademy.com; pct=100; adkim=s; aspf=s
```

**What this means**:
- `p=quarantine`: Failed emails go to spam (use `p=reject` for stricter policy)
- `rua=mailto:dmarc@albaqiacademy.com`: Where to send reports
- `pct=100`: Apply to 100% of emails
- `adkim=s; aspf=s`: Strict alignment for DKIM and SPF

### Step 2: Prepare Your Logo for BIMI

BIMI requires your logo in **SVG Tiny PS** format. Here's how to prepare it:

#### Convert Your Logo to SVG
1. Use an online tool or Adobe Illustrator to convert `logo.png` to SVG
2. Ensure it's **SVG Tiny Portable/Secure (SVG Tiny PS)** format
3. Square aspect ratio (1:1)
4. Maximum 32KB file size

**Online conversion tools**:
- https://www.iloveimg.com/svg-converter
- https://convertio.co/png-svg/
- https://cloudconvert.com/png-to-svg

#### Upload Your SVG Logo
Upload the SVG to a publicly accessible HTTPS URL:
- Option 1: Upload to `https://albaqiacademy.com/bimi/logo.svg`
- Option 2: Use a CDN or cloud storage

### Step 3: Create BIMI DNS Record

Add this TXT record to your DNS:

```
Name: default._bimi
Type: TXT
Value: v=BIMI1; l=https://albaqiacademy.com/bimi/logo.svg;
```

**Note**: For enhanced BIMI (verified mark), you need a VMC (Verified Mark Certificate):
```
Value: v=BIMI1; l=https://albaqiacademy.com/bimi/logo.svg; a=https://albaqiacademy.com/bimi/vmc.pem;
```

### Step 4: DNS Configuration Summary

Add these records to your IONOS DNS settings for `albaqiacademy.com`:

| Name | Type | Value | Priority |
|------|------|-------|----------|
| @ | TXT | `v=spf1 include:kundenserver.de ~all` | - |
| default._domainkey | TXT | `v=DKIM1; k=rsa; p=YOUR_DKIM_KEY` | - |
| _dmarc | TXT | `v=DMARC1; p=quarantine; rua=mailto:dmarc@albaqiacademy.com; pct=100; adkim=s; aspf=s` | - |
| default._bimi | TXT | `v=BIMI1; l=https://albaqiacademy.com/bimi/logo.svg;` | - |

### Step 5: Verify Setup

After adding DNS records (allow 24-48 hours for propagation):

#### Check SPF:
```bash
dig albaqiacademy.com TXT | grep spf
```

#### Check DKIM:
```bash
dig default._domainkey.albaqiacademy.com TXT
```

#### Check DMARC:
```bash
dig _dmarc.albaqiacademy.com TXT
```

#### Check BIMI:
```bash
dig default._bimi.albaqiacademy.com TXT
```

#### Online Verification Tools:
- **MXToolbox**: https://mxtoolbox.com/SuperTool.aspx
- **DMARC Analyzer**: https://www.dmarcanalyzer.com/
- **BIMI Inspector**: https://bimigroup.org/bimi-generator/

---

## Testing

### Test Email with Logo
Send a test email from the admin dashboard:
1. Log in as admin
2. Go to Admin Dashboard → Test Email
3. Send test email to your Gmail/Yahoo address
4. Check if logo displays inline

### Verify BIMI Display (Gmail)
1. Send email to a Gmail address
2. Wait 24-48 hours after DNS setup
3. Check if your logo appears next to sender name in Gmail inbox

**Note**: BIMI only works with:
- Gmail
- Yahoo Mail
- Fastmail
- Some other providers

---

## Quick Start Checklist

- [ ] Logo embeds in emails (already done ✅)
- [ ] Add SPF record to DNS
- [ ] Add DKIM record to DNS (get from IONOS)
- [ ] Add DMARC record to DNS
- [ ] Convert logo.png to SVG Tiny PS format
- [ ] Upload SVG to public HTTPS URL
- [ ] Add BIMI record to DNS
- [ ] Wait 24-48 hours for DNS propagation
- [ ] Test with MXToolbox and BIMI Inspector
- [ ] Send test emails to Gmail/Yahoo

---

## Support

For IONOS DNS setup help:
- **IONOS Support**: https://www.ionos.com/help/
- **IONOS DNS Guide**: Check your IONOS control panel under "Domains & SSL"

For BIMI questions:
- **BIMI Group**: https://bimigroup.org/
- **BIMI FAQ**: https://bimigroup.org/faqs-for-senders/

---

## Current Email Configuration

Based on your logs, your current setup:
- **SMTP Server**: kundenserver.de (IONOS)
- **From Address**: noreply@albaqiacademy.com
- **Authentication**: Working ✅
- **TLS/SSL**: Enabled ✅

**Next Priority**: Add SPF, DKIM, and DMARC records to improve deliverability and enable BIMI.
