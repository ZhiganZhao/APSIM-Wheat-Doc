# Stem {#cha:stem}




`Stem` provides biomass through retranslocation, requires biomass a proportion of daily fixation (i.e. photosynthesis in `Leaf`). The biomass is allocated into two components, i..e `Structural` and `Storage`. No `Metabolic` is considered.


## Supply {#sec:stem-supply}

In `Stem`, the biomass supply only sources from retranslocation (Fig. \@ref(fig:stem-supply)). Daily retranslocation is the proportion of current storage ($W_{stem, storage}$). The default value of proportion is 0.5 since `StartGrainFill`, i.e. retranslocatable biomsss is 50% during grain filling (Fig. \@ref(fig:stem-retran-factor)).


<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-retran-factor-1.png" alt="Growth duration of stem development" width="80%" />
<p class="caption">(\#fig:stem-retran-factor)Growth duration of stem development</p>
</div>
</div>



<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-supply-1.png" alt="Biomass supply from stem" width="80%" />
<p class="caption">(\#fig:stem-supply)Biomass supply from stem</p>
</div>
</div>


## Demand {#sec:stem-demand}

The daily biomass demand of `Stem` is calculated as a fraction of daily fixation (i.e. photosynthesis) from Stage 3 (`Emergence`) to Stage 6 (`Flowering time`) (Fig. \@ref(fig:stem-demand-fraction)) and increases at Stage 4 (`Terminal spikelet`) (Fig. \@ref(fig:stem-demand-fraction)). After `Flowering time`, no biomass allocated into stem (Fig. \@ref(fig:stem-demand)).  

<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-demand-fraction-1.png" alt="Fraction of stem demand in the total fixation " width="80%" />
<p class="caption">(\#fig:stem-demand-fraction)Fraction of stem demand in the total fixation </p>
</div>
</div>




<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-demand-1.png" alt="Biomass demand by stem" width="80%" />
<p class="caption">(\#fig:stem-demand)Biomass demand by stem</p>
</div>
</div>

## Biomass dynamic {#sec:stem-biomass}

The actual allocation reflects the increase of structural component, and retranslocation of storage component (Fig. \@ref(fig:stem-allocated)). `Stem` only considers the `Live` biomass (Fig. \@ref(fig:stem-live), no `Dead` biomass (Fig. \@ref(fig:stem-dead)).


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-allocated-1.png" alt="Actual allocated biomass for stem" width="80%" />
<p class="caption">(\#fig:stem-allocated)Actual allocated biomass for stem</p>
</div>
</div>


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-weight-1.png" alt="Dynamic of stem biomass (Total)" width="80%" />
<p class="caption">(\#fig:stem-weight)Dynamic of stem biomass (Total)</p>
</div>
</div>




<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-live-1.png" alt="Dynamic of stem biomass (Live component)" width="80%" />
<p class="caption">(\#fig:stem-live)Dynamic of stem biomass (Live component)</p>
</div>
</div>


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="stem_files/figure-html/stem-dead-1.png" alt="Dynamic of stem biomass (Dead component)" width="80%" />
<p class="caption">(\#fig:stem-dead)Dynamic of stem biomass (Dead component)</p>
</div>
</div>




