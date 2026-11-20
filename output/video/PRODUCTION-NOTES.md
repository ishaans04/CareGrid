# CareGrid — Every second, accounted for.

**Team Duality · Ishaan Sharma and Hriday Vig**

Final film: 2 minutes 50 seconds, 1920 × 1080, 30 fps, H.264 video and stereo AAC audio. English captions are burned into the picture; the SRT is also supplied separately.

The film follows one clear story: ask for help, review and approve dispatch, record the crew's progress, prepare the receiving team, and close with a recorded outcome. It then shows readiness rehearsal, the Google Cloud deployment, and the proposed pilot.

| Time | Scene |
| --- | --- |
| 00:00 | 02:17 at Birch Hostel — who is actually coming? |
| 00:13 | The gaps between phone calls and handoffs |
| 00:25 | Meet CareGrid |
| 00:35 | Student SOS |
| 00:48 | Command review, ownership and approved dispatch |
| 01:05 | Crew acceptance, departure and on-scene check-in |
| 01:20 | Care readiness, recorded care and human closure |
| 01:34 | Proof of Response and missed-step escalation |
| 01:50 | Readiness lab and one predicted improvement |
| 02:10 | Google Cloud |
| 02:23 | Proposed supervised pilot |
| 02:36 | Team Duality and closing promise |

## Source and truth boundaries

- The creative direction was based on all 13 pages of the supplied **CareGrid Team Duality Pitch Deck.pdf**. The PDF itself is not redistributed in the source archive.
- Product screens were captured from the finalized UI at main `6335dc0`, using an isolated local Serverpod/PostgreSQL database and authenticated synthetic personas. There are no mocked provider responses. The underlying application source was not changed.
- The exported captures follow **INC-1027** through actual UI actions. Screen changes are edited captures, with an illustrated cursor added to make the recorded actions clear. The film is a designed demo, not an unedited real-time screen recording.
- All campus incidents, people and milestones shown are synthetic. The opening campus drawing is an original schematic, not a surveyed map or live location display.
- The readiness engine returned **6m 41s predicted arrival**, a **5m target**, and **4m 12s with the combined proposed fixes**. The film displays this prediction; it does not claim a measured improvement in a real emergency or a deployed campus pilot.
- The Google Cloud section describes the existing staging deployment. The UI filming used local PIN personas, not a new acceptance test of live Google OAuth. Gemini drafting, live camera ingestion, push notification integrations and clinical outcomes are not claimed in this film.
- Narration was synthesized with Google Cloud Text-to-Speech (`en-US-Chirp3-HD-Charon`). This API was enabled in `caregrid-staging` for production of the film. Credentials stayed in process memory and are not included in the project.
- The stereo score and transition swells were composed procedurally for this film. No third-party music, stock footage, celebrity voice, or external sample pack is used.
- Inter and Geist Mono are the project's self-hosted fonts. Their SIL Open Font License notices are included in the source archive.
- Captions are timed within each synthesized scene recording. Their short phrase timings are proportional estimates, rather than forced word alignment.

## FFmpeg

FFmpeg performs frame encoding, narration placement, music ducking, loudness treatment, audio/video muxing and final playback checks. The browser canvas supplies deterministic motion-graphic frames; FFmpeg encodes the finished movie.

- [FFmpeg source mirror requested for the project](https://github.com/FFmpeg/FFmpeg)
- [Official download page](https://ffmpeg.org/download.html)
- [Windows build linked from the official page](https://www.gyan.dev/ffmpeg/builds/)
- [FFmpeg filter reference](https://ffmpeg.org/ffmpeg-filters.html)
- [Google narration documentation](https://docs.cloud.google.com/text-to-speech/docs/chirp3-hd)

Tool used: **FFmpeg 9.1 essentials build**. The downloaded build archive SHA-256 matched its publisher's checksum:

`835b9a733445ba7a56a37a26cf7bde84e2f3ce7da2a8ec984276bb2abb1b922c`

The source archive contains the composition, narration script, captured UI, voice stems, original score, fonts and render tools. It contains no cloud credentials, database secrets, FFmpeg executable, or production Terraform state.
