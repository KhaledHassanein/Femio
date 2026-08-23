# 28.04 — GO Flo (com.go.flo), torn down

`com.go.flo` 1.1.9. 11 MB, 5,346 classes, 45 activities. This is not a competitor to
Femio in any meaningful product sense, and the chapter is short because it does not
need to be long. It earns its place for one reason: it is the clearest available
illustration of what a period tracker looks like when it is built as an advertising
surface, and it makes Femio's product rule 4 concrete rather than abstract.

## 1. Who built it

The package tree names the owner without ambiguity: `com.jiubang`, `com.gomo`,
`com.gau`, `com.jb`. This is the GO Launcher family — a Chinese mobile ad-tech
group. The app is one of many verticals built on a shared monetisation platform,
and the shared platform is visible in the source: `com.go.flo.function.daemonsdk`
and a `ProcessDaemonSdk-svnlog.properties` in the resources.

The app is old. It still uses GCM/C2DM (`com.google.android.c2dm.permission.RECEIVE`,
`com.go.flo.permission.C2D_MESSAGE`), a messaging API Google deprecated years ago.

## 2. The advertising stack

Four ad and attribution SDKs ship inside an 11 MB menstrual tracker:

| SDK | Evidence |
|---|---|
| MoPub | `com.mopub.mobileads.MoPubActivity`, `MraidActivity`, `MraidVideoPlayerActivity`, `MoPubBrowser` |
| Facebook Audience Network | `com.facebook.ads.AudienceNetworkActivity` |
| AppsFlyer | `com.appsflyer.MultipleInstallBroadcastReceiver` |
| Google Mobile Ads | `com.google.android.gms.ads.AdActivity`, `MobileAdsInitProvider` |

Plus Twitter and Facebook login SDKs, Crashlytics, and a `mediation` package for
waterfall ad mediation.

## 3. The permission profile

This is the part worth quoting in a compliance conversation:

```
READ_PHONE_STATE            GET_ACCOUNTS
SYSTEM_ALERT_WINDOW         MOUNT_UNMOUNT_FILESYSTEMS
GET_TASKS                   WRITE_EXTERNAL_STORAGE
ACCESS_WIFI_STATE           RECEIVE_BOOT_COMPLETED
```

`READ_PHONE_STATE` yields device and SIM identifiers. `GET_ACCOUNTS` enumerates the
accounts on the device. `SYSTEM_ALERT_WINDOW` draws over other apps.
`MOUNT_UNMOUNT_FILESYSTEMS` is a privileged storage permission with no plausible
purpose in a period tracker. `GET_TASKS` reports what else the user is running.
Combined with a process-daemon SDK whose job is to keep the app alive against the
system's wishes, this is a device-fingerprinting and persistence profile, not a
health app's profile.

There is a `function/gdpr` package, so consent screens exist. They sit on top of all
of the above.

## 4. What it actually does

The product surface is thin: `function/home`, `function/record` (logging),
`function/analysis`, `function/notification`, `function/settings`,
`function/language`, `function/feedback`, `function/about`, and
`function/feellucky`. A calendar, some logging, a basic analysis view. Forty-five
activities, most of which belong to the ad and account SDKs rather than to the
product.

## 5. The localisation claim, corrected

At first glance this app appears to ship over 140 locales, including `ar` and
`ar-rEG` — which would have made it the only app in this study with Arabic. It does
not.

Counting only the app's own strings and excluding AndroidX, Material, Facebook SDK
and other library resources:

| Locale | App strings translated | Default (`values/`) |
|---|---|---|
| French | 621 | 764 |
| **Arabic** | **40** | 764 |

The Arabic file is almost entirely `abc_*` AndroidX library strings that came free
with the support library. Forty app strings is a stub, not a translation. French, by
contrast, is a real and essentially complete localisation.

So the corrected finding, and it holds across the whole study: **none of the three
apps ships a real Arabic translation, and the market leader does not even mirror its
layout for RTL.** Femio's Arabic-and-RTL-first commitment is unopposed by any of
them.

## 6. Why this chapter exists

Two reasons, both useful.

First, as the argument for rule 4. Femio's non-negotiable "no ad or analytics SDK
access to health data" can read like a self-imposed handicap in a market where Flo
runs AppsFlyer with consent and the pregnancy tracker runs AdMob interstitials. This
app is the end of that road: once advertising is the business model, the permission
manifest follows, and a woman's cycle data ends up adjacent to a device-fingerprinting
SDK and a mediation waterfall. It is worth keeping the permission list above in the
compliance pack (`docs/13`) as the concrete example.

Second, as a reminder that app-store presence is not evidence of quality. This app
sits in the same store category as Flo and as whatever Femio ships. Users cannot see
a permission manifest. Verifiable privacy — the kind Femio intends to make
demonstrable rather than merely claimed — is only a differentiator if we make it
visible in the product.
