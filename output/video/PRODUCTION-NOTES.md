# CareGrid — From signal to response

**Team Duality · Ishaan Sharma and Hriday Vig**

120 seconds · 1920 × 1080 · 30 fps · H.264 / AAC stereo. English captions are burned into the picture and supplied separately. This revision replaces the earlier 170-second film.

## Chapters

| Time | Chapter |
| --- | --- |
| 00:00 | 02:17 / BIRCH HOSTEL |
| 00:06 | ONE CAMPUS RESPONSE SYSTEM |
| 00:13 | 01 / VERIFY THE SIGNAL |
| 00:23 | 02 / TAKE OWNERSHIP |
| 00:31 | 03 / COORDINATE THE CAMPUS |
| 00:39 | 04 / PROVE THE RESPONSE |
| 00:48 | 05 / REACH CARE |
| 00:55 | SILENCE NEVER COUNTS AS SUCCESS |
| 01:04 | REHEARSE / FIX / REPEAT |
| 01:15 | LEARN FROM EVERY RESPONSE |
| 01:23 | THE RIGHT CONTEXT / THE RIGHT ROLE |
| 01:31 | BUILT ON GOOGLE CLOUD |
| 01:43 | ONE CAMPUS / MANY POSSIBILITIES |
| 01:51 | TEAM DUALITY |

## Visual direction

The film uses the application's Inter and Geist Mono fonts, real CareGrid logo, white/blue/butter-yellow palette and captured UI. Camera scanning, device pulses, moving campus routes, per-unit progress, kinetic typography and wipes are original canvas animation. The CCTV illustration and campus plan are extracted from CareGrid's own presentation and landing assets. No stock footage or invented live surveillance footage is used.

## Source and truth boundaries

- The supplied 13-page **CareGrid Team Duality Pitch Deck.pdf** informed the story. The PDF is not redistributed.
- Screens were captured from main commit **0628a012c289112ebff32933b8215054e94a52cf** with an isolated local Serverpod/PostgreSQL database and authenticated synthetic personas. Application code was not changed. The movie is an edited demonstration, not a real-time screen recording.
- CCTV case **INC-1025**, scenario **SC-HOSTEL-0217**, uses two normalized synthetic camera signals, CAM-HB-B07 and CAM-HB-B08. The application verifies the case against **SOP-HST-MED-NIGHT**; a human operator owns and dispatches it. The camera drawing and tracking overlay are illustrative; live inference and hardware adapters are not demonstrated.
- Both security and ambulance actually accepted, departed, checked in and recorded care through the application. A human recorded the closing outcome. Supplied synthetic case JSON preserves the final evidence. Scene timing compresses these actions for presentation.
- The smoke case **SC-LAB-SMOKE** uses actual normalized camera and **iotSensor** inputs through the local scenario engine. CCTV, IoT, staff and SOS share the response model. Access-control and vehicle connectors in the device graphic describe intended integrations, not completed hardware deployments.
- The animated route follows the actual recommended campus path **HOS → J4 → HB**: 458 m / 85 s estimated mobilization and travel. It is a campus schematic, not GPS telemetry.
- The readiness baseline predicted **6m 41s** against a **5m** target. Three fixes were applied through the real UI: open gate G4, restage ambulance A1 at HOS, and restore CAM-HB-B08. The actual rerun predicted **2m 22s** for the hostel case; the full suite passed **3/4 cases (75%)**. These are model predictions, not measured emergency outcomes. The earlier proposed combined estimate of 4m 12s is not the rerun result.
- Countdown and escalation graphics explain deadline behavior; they do not represent a newly staged live production incident. Audit and after-action screens contain fictional data. Campus scope is enforced by the application backend; filming used local personas rather than retesting live Google OAuth.
- The Google section describes the existing staging architecture: Firebase Authentication, Cloud Run, Cloud SQL, deadline watchdog, Logging and Monitoring. Gemini handoff drafting is implemented but gated for evaluation. No new app deployment was made to produce the film.
- Narration uses Google Cloud Text-to-Speech, **en-US-Chirp3-HD-Charon**, with scene-level retiming. Captions use proportional phrase timings rather than forced alignment. No credentials are included.
- The original 120 BPM stereo score and transition sounds are procedural, with no external music or samples. Inter and Geist Mono SIL Open Font License notices are included.

## Reproduction

Extract the editable project and follow its README. It includes the composition, renderer, story, captures, synthetic case evidence, narration stems, original score, brand files and font licenses. It excludes credentials, private database configuration, Terraform state and FFmpeg binaries.

FFmpeg performs frame encoding, narration retiming and placement, sidechain music ducking, loudness treatment, muxing and playback checks. Canvas renders animation deterministically at a 60 fps internal timebase; the delivery is 30 fps.

- [FFmpeg source](https://github.com/FFmpeg/FFmpeg)
- [Official downloads](https://ffmpeg.org/download.html)
- [Windows build](https://www.gyan.dev/ffmpeg/builds/)
- [FFmpeg filters](https://ffmpeg.org/ffmpeg-filters.html)
- [Google narration documentation](https://docs.cloud.google.com/text-to-speech/docs/chirp3-hd)

Tool: FFmpeg 9.1 essentials build. Download archive SHA-256 matched the publisher: `835b9a733445ba7a56a37a26cf7bde84e2f3ce7da2a8ec984276bb2abb1b922c`.
