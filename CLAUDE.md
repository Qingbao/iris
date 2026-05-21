# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

MATLAB implementation comparing two iris-recognition segmentation approaches on the CASIA Iris Image Database v1.0 (756 images, 108 subjects, 320x280 grayscale BMPs). The two approaches live in sibling directories and share most of the downstream pipeline (normalisation, encoding, matching, EER):

- [Daugman/](Daugman/) — iris/pupil boundaries found by Daugman's integro-differential operator ([SearchInnerBoundary.m](Daugman/SearchInnerBoundary.m), [SearchOuterBoundary.m](Daugman/SearchOuterBoundary.m), [ContourIntegralCircular.m](Daugman/ContourIntegralCircular.m)). Reported EER on CASIA v1.0: 0.0157.
- [Hough/](Hough/) — iris/pupil boundaries found by circular Hough transform ([findcircle.m](Hough/findcircle.m), [houghcircle.m](Hough/houghcircle.m)). Reported EER on CASIA v1.0: 0.0500.

The two `segmentiris.m` files are the *only* meaningful divergence between the directories — same-named files outside segmentation (encode, normaliseiris, gaborconvolve, gethammingdistance, shiftbits, canny, etc.) are the open-source Libor Masek pipeline and behave identically in both. When fixing a bug in shared code, mirror the change to both directories.

## Pipeline (run from inside `Daugman/` or `Hough/`)

The scripts are not parameterized — they hardcode paths and indices. Edit the path constants before running. There is no test framework; "running a single test" means invoking one script in MATLAB.

1. **Prepare images** — [read_all_images.m](Daugman/read_all_images.m): converts CASIA BMPs to JPGs and dumps `data.mat`. Edit `path` / `subpath` at the top to point at your CASIA directory. The triple-nested numbering (`00`/`0`/empty prefix at thresholds 10 and 100) reflects the CASIA folder layout — leave it alone unless the dataset layout changes.
2. **Build templates** — [loadimages.m](Daugman/loadimages.m): iterates 108 subjects x 7 images each, calls [createiristemplate.m](Daugman/createiristemplate.m) per image, and writes `template.mat` + `mask.mat`. Each column is one image's flattened 20x480 = 9600-bit template/mask.
3. **Score pairs** — [matching.m](Daugman/matching.m): computes Hamming distances. Intra-class and inter-class blocks are mutually exclusive — *one is commented out at any time*. Run once with intra-class enabled to produce `HD_same.mat`, then again with inter-class enabled to produce `HD_diff.mat`. The toggle is by commenting, not by flag.
4. **Compute EER** — [EER_duagman.m](Daugman/EER_duagman.m) / [EER_hough.m](Hough/EER_hough.m): loads both HD files, sweeps threshold 0..1 in 0.01 steps, finds the FMR/FNMR crossover.

Column indexing convention used throughout: subject `i` occupies columns `7*(i-1)+1 .. 7*i`, with sub-images `1..3` from session 1 and `4..7` from session 2. Don't change the stride without updating every script.

## Things to know before editing

- `createiristemplate.m` writes a segmented-overlay JPG to a `diagnostics/` subdirectory via `cd(DIAGPATH)`. That directory must exist before `loadimages.m` is run, or the `cd` fails silently and the image isn't written. The mat-file caching block (`-houghpara.mat`) is commented out — every run re-segments.
- Segmentation tuning constants (`lpupilradius`, `upupilradius`, `lirisradius`, `uirisradius`, eyelash threshold) live near the top of `segmentiris.m` and are tuned for CASIA. There are commented-out "LIONS" values for the alternate dataset. The Daugman variant additionally uses `eyeimage < 80` for eyelash masking; the Hough variant uses `< 100`.
- Templates are encoded with `nscales=1, minWaveLength=18, sigmaOnf=0.5` and normalised at `radial_res=20, angular_res=240`. These produce the 9600-bit budget the matching code assumes (`reshape(..., 20, 480)` — 480 = 2 x angular_res for real+imag of the 1D Log-Gabor response). Changing any of these breaks the reshape.
- `matching.m` rotation invariance: `gethammingdistance(t1, m1, t2, m2, 1)` — the trailing `1` is the number of shift positions; encoded inside [shiftbits.m](Daugman/shiftbits.m).

## License note

Per [README.md](README.md): the algorithm sources are open-source (Libor Masek's pipeline) with slight modifications. Check [LICENSE](LICENSE) before reusing code.
