# Grain {#cha:grain}






## Grain number {#sec:grain-number}

The number of grains per plant ($N_{g}$) is determined by the `Stem` and `Spike` total biomass at `Flowering` (including `Live` and `Dead`).
$$
N_{g}=R_{g}(W_{stem} + W_{spike})
$$
where $W_{stem}$ and $W_{spike}$ are the stem and spkie total biomass at flowering, respectively. R_{g} is the grain number per gram stem and spike, with default value at 22 grain g<sup>-1</sup>.




## Supply {#sec:grain-supply}

No biomass supply is considered in the `Grain` organ (Fig. \@ref(fig:grain-supply)).


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-supply-1.png" alt="Biomass supply from grain" width="80%" />
<p class="caption">(\#fig:grain-supply)Biomass supply from grain</p>
</div>
</div>


## Demand {#sec:grain-demand}
The grain demand is seperated into two periods (i.e. from `Flowering` to `StartGrainFill` and from `StartGrainFill` to `EndGrainFill`). 


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-demand-1.png" alt="Biomass demand by grain" width="80%" />
<p class="caption">(\#fig:grain-demand)Biomass demand by grain</p>
</div>
</div>

## Biomass dynamic {#sec:grain-dynamic}

`Grain` only considers the `Live` conponent, No `Dead` component.



<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-allocated-1.png" alt="Actual allocated biomass for grain" width="80%" />
<p class="caption">(\#fig:grain-allocated)Actual allocated biomass for grain</p>
</div>
</div>




<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-weight-1.png" alt="Dynamic of grain biomass (Total)" width="80%" />
<p class="caption">(\#fig:grain-weight)Dynamic of grain biomass (Total)</p>
</div>
</div>





<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-live-1.png" alt="Dynamic of grain biomass (Live component)" width="80%" />
<p class="caption">(\#fig:grain-live)Dynamic of grain biomass (Live component)</p>
</div>
</div>


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="grain_files/figure-html/grain-dead-1.png" alt="Dynamic of grain biomass (Dead component)" width="80%" />
<p class="caption">(\#fig:grain-dead)Dynamic of grain biomass (Dead component)</p>
</div>
</div>




