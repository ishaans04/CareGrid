# CareGrid product demo

**Every second, accounted for.** A two-minute film by Team Duality: a CCTV signal becomes a verified case, an approved response, and a recorded care outcome. IoT, staff reports and SOS connect to the same system.

[![CareGrid demo poster](CareGrid-poster.png)](CareGrid-Team-Duality.mp4)

**[Watch or download the video](CareGrid-Team-Duality.mp4)**

| File | Purpose |
| --- | --- |
| [MP4](CareGrid-Team-Duality.mp4) | Finished 1920 × 1080, 16:9, 30 fps film; H.264 and 48 kHz stereo AAC |
| [English captions](CareGrid-Team-Duality.srt) | Separate SRT; captions are also burned into the picture |
| [Poster](CareGrid-poster.png) | Clean 1920 × 1080 title image |
| [Storyboard](CareGrid-storyboard.jpg) | Overview of every chapter |
| [Editable project](CareGrid-editable-project.zip) | Canvas composition, narration, UI captures, voice stems, original score and FFmpeg renderer |
| [Production notes](PRODUCTION-NOTES.md) | Chapters, provenance and simulation boundaries |
| [Export verification](export-verification.json) | Media properties and full-file decoding check |
| [SHA-256 checksums](checksums.sha256) | Integrity hashes |

The faster cut uses CareGrid's actual white, blue and butter-yellow design, animated camera tracking, connected device pulses, a campus route, per-unit milestones and transitions. It covers verification, command, security, ambulance, care, escalation, readiness, after action, roles and Google Cloud.

Product screens come from the finalized application with a real local Serverpod/PostgreSQL backend and fictional campus data. CCTV and IoT signals are simulated normalized inputs; the film does not claim a live hardware deployment or live video inference. Readiness results are predictions. See the production notes for details.

FFmpeg encodes the animation, retimes narration, ducks the original music, muxes the movie and verifies decoding. The editable archive includes everything needed to render from the supplied audio without cloud credentials.
