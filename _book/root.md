# Root {#cha:root}





Only `Structural` is considered in the three components of biomass for `Root`. The biomass allocation depending on the fraction of daily fixation (i.e. photosynthesis).



## Root length {#sec:root-length}


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-length-1.png" alt="Root length" width="80%" />
<p class="caption">(\#fig:root-length)Root length</p>
</div>
</div>





## Supply {#sec:root-supply}

No biomass supply is considered in the `Root` organ (Fig. \@ref(fig:root-supply)).

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-supply-1.png" alt="Biomass supply from root" width="80%" />
<p class="caption">(\#fig:root-supply)Biomass supply from root</p>
</div>
</div>


## Demand {#sec:root-demand}

The daily biomass demand of `Root` is calculated as a fraction of daily fixation (i.e. photosynthesis) from Stage 3 (`Emergence`) to Stage 8 (`End of grain filling`). The fraction of root demand is 0.2 until `Flowering time`, then reduces into 0.02 until `End of grain filling` (Fig. \@ref(fig:root-demand-fraction)). Only structural demand is considered in the `Root` organ (Fig. \@ref(fig:root-demand)). 



<div class="rmdnote">
<p>Photosynthate is not partitioned into root after heading <span class="citation">[@Fangsituassessmentnew2016]</span>.</p>
</div>



<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-demand-fraction-1.png" alt="Fraction of root demand in the total fixation " width="80%" />
<p class="caption">(\#fig:root-demand-fraction)Fraction of root demand in the total fixation </p>
</div>
</div>




<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-demand-1.png" alt="Biomass demand by root" width="80%" />
<p class="caption">(\#fig:root-demand)Biomass demand by root</p>
</div>
</div>

## Biomass dynamic {#sec:root-biomass}

The actual allocation (Fig. \@ref(fig:root-allocated)) is determined by the actual daily biomass supply (Fig. \@ref(fig:biomass-supply-total)) which may be smaller than than biomass demand (Fig. \@ref(fig:root-demand)). 

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-allocated-1.png" alt="Actual allocated biomass for root" width="80%" />
<p class="caption">(\#fig:root-allocated)Actual allocated biomass for root</p>
</div>
</div>

The daily loss of roots is calculated using a SenescenceRate function (0.005 in the default value).  All senesced material is automatically detached and added to the soil fresh organic matter (FOM) pool.  

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-detached-1.png" alt="Detached biomass from root into soil organic." width="80%" />
<p class="caption">(\#fig:root-detached)Detached biomass from root into soil organic.</p>
</div>
</div>


Finally `Root` biomass increases until `flowering time`, then gradually decreases as the senescence is more than allocation (Fig. \@ref(fig:root-weight)). All biomass is allocated into `Live` component (Fig. \@ref(fig:root-live)), as the senescenced `Root` immediately is detached and contributed into soil FOM (Fig. \@ref(fig:root-dead)).

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-weight-1.png" alt="Dynamic of root biomass (Total)" width="80%" />
<p class="caption">(\#fig:root-weight)Dynamic of root biomass (Total)</p>
</div>
</div>



<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-live-1.png" alt="Dynamic of root biomass (Live component)" width="80%" />
<p class="caption">(\#fig:root-live)Dynamic of root biomass (Live component)</p>
</div>
</div>


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="root_files/figure-html/root-dead-1.png" alt="Dynamic of root biomass (Dead component)" width="80%" />
<p class="caption">(\#fig:root-dead)Dynamic of root biomass (Dead component)</p>
</div>
</div>


