1) to linearize the model, run: linearize_plant
2) to optimize gains with fminsearch, run:
	a) iff_single_altopt - for single-gain
	b) iff_diag_altopt - for multi-gain
*3) to optimize gains with hinfstruct (unrecommended), run:
	a) iff_multiop
4) to compare laws according to thesis, run: compare_laws_alt
*5) to compare laws obtained by hinfstruct, run: compare_laws