within IBPSA.Media.Antifreeze;
package PropyleneGlycolWater
  "Package with model for propylene glycol - water with constant properties"
  extends Modelica.Icons.VariantsPackage;

  constant Modelica.SIunits.Temperature property_T
    "Temperature for evaluation of constant fluid properties";
  constant Modelica.SIunits.MassFraction massFraction
    "Mass fraction of propylene glycol in water";
  constant Modelica.SIunits.MassFraction massFraction_min=0.
    "Minimum allowed mass fraction of propylene glycol in water";
  constant Modelica.SIunits.MassFraction massFraction_max=0.6
    "Maximum allowed mass fraction of propylene glycol in water";

  // Coefficients for evaluation of physical properties
  constant IBPSA.Media.Antifreeze.BaseClasses.PropertyCoefficients
    propertyCoefficients(
    each wm=0.307031,
    each Tm=Modelica.SIunits.Conversions.from_degC(32.7083),
    each nw=6,
    each nT={4,4,4,3,2,1},
    each nTot=18,
    each a_d={1.018e3, -5.406e-1, -2.666e-3, 1.347e-5, 7.604e-1, -9.450e-3, 5.541e-5, -1.343e-7, -2.498e-3, 2.700e-5, -4.018e-7, 3.376e-9, -1.550e-4, 2.829e-6, -7.175e-9, -1.131e-6, -2.221e-8, 2.342e-8},
    each a_eta={6.837e-1, -3.045e-2, 2.525e-4, -1.399e-6, 3.328e-2, -3.984e-4, 4.332e-6, -1.860e-8, 5.453e-5, -8.600e-8, -1.593e-8, -4.465e-11, -3.900e-6, 1.054e-7, -1.589e-9, -1.587e-8, 4.475e-10, 3.564e-9},
    each a_Tf={-1.325e1, -3.820e-5, 7.865e-7, -1.733e-9, -6.631e-1, 6.774e-6, -6.242e-8, -7.819e-10, -1.094e-2, 5.332e-8, -4.169e-9, 3.288e-11, -2.283e-4, -1.131e-8, 1.918e-10, -3.409e-6, 8.035e-11, 1.465e-8},
    each a_cp={3.882e3, 2.699e0, -1.659e-3, -1.032e-5, -1.304e1, 5.070e-2, -4.752e-5, 1.522e-6, -1.598e-1, 9.534e-5, 1.167e-5, -4.870e-8, 3.539e-4, 3.102e-5, -2.950e-7, 5.000e-5, -7.135e-7, -4.959e-7},
    each a_lambda={4.513e-1, 7.955e-4, 3.482e-8, -5.966e-9, -4.795e-3, -1.678e-5, 8.941e-8, 1.493e-10, 2.076e-5, 1.563e-7, -4.615e-9, 9.897e-12, -9.083e-8, -2.518e-9, 6.543e-11, -5.952e-10, -3.605e-11, 2.104e-11});

  // Fluid constants based on pure Propylene Glycol
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simplePropyleneGlycolWaterConstants(
    each chemicalFormula="C3H8O2",
    each structureFormula="CH3CH(OH)CH2OH",
    each casRegistryNumber="57-55-6",
    each iupacName="1,2-Propylene glycol",
    each molarMass=0.07609);


  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimplePropyleneGlycolWater",
    final cp_const=polynomialSpecificHeatCapacityCp(massFraction,property_T),
    final cv_const=cp_const,
    final d_const=polynomialDensity(massFraction,property_T),
    final eta_const=polynomialDynamicViscosity(massFraction,property_T),
    final lambda_const=polynomialThermalConductivity(massFraction,property_T),
    a_const=1484,
    final T_min=polynomialFusionTemperature(massFraction,property_T),
    final T_max=Modelica.SIunits.Conversions.from_degC(100),
    T0=273.15,
    MM_const=(massFraction/simplePropyleneGlycolWaterConstants[1].molarMass+(1-massFraction)/0.018015268)^(-1),
    fluidConstants=simplePropyleneGlycolWaterConstants,
    p_default=300000,
    reference_p=300000,
    reference_T=273.15,
    reference_X={1},
    AbsolutePressure(start=p_default),
    Temperature(start=T_default),
    Density(start=d_const));

  redeclare model BaseProperties "Base properties"
    Temperature T(stateSelect=
      if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Temperature of medium";

    InputAbsolutePressure p "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.SIunits.SpecificInternalEnergy u
      "Specific internal energy of medium";
    Modelica.SIunits.Density d=d_const "Density of medium";
    Modelica.SIunits.MassFraction[nX] X={1}
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.SIunits.SpecificHeatCapacity R=0
      "Gas constant (of mixture if applicable)";
    final Modelica.SIunits.MolarMass MM=MM_const
      "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation(Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T)
      "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

    // Local connector definition, used for equation balancing check
    connector InputAbsolutePressure = input Modelica.SIunits.AbsolutePressure
      "Pressure as input signal connector";
    connector InputSpecificEnthalpy = input Modelica.SIunits.SpecificEnthalpy
      "Specific enthalpy as input signal connector";
    connector InputMassFraction = input Modelica.SIunits.MassFraction
      "Mass fraction as input signal connector";

  equation
    assert(T >= T_min and T <= T_max, "
Temperature T (= " + String(T) + " K) is not
in the allowed range (" + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \"" + mediumName + "\".
");
    assert(massFraction >= massFraction_min and massFraction <= massFraction_max, "
    Mass fraction massFraction (= " + String(massFraction) + " ) is not
in the allowed range (" + String(massFraction_min) + " <= massFraction <= " + String(massFraction_max) + " )
required from medium model \"" + mediumName + "\".
");

    h = cp_const*(T-reference_T);
    u = h;
    state.T = T;
    state.p = p;

    annotation(Documentation(info="<html>
    <p>
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>u = cv_const*(T - reference_T)</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    Also, the model checks if the mass fraction of the mixture is within the
    allowed limits.
    </p>
</html>"));
  end BaseProperties;

  replaceable function polynomialDensity "Evaluate density of antifreeze-water mixture"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.MassFraction w "Mass fraction of antifreeze";
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    output Modelica.SIunits.Density d "Density of antifreeze-water mixture";
  algorithm
    d := polynomialProperty(w*100 "fixme: why multiplying by 100?",
                            T,
                            propertyCoefficients.wm*100,
                            propertyCoefficients.Tm,
                            propertyCoefficients.nw,
                            propertyCoefficients.nT,
                            propertyCoefficients.a_d)
    annotation (
    Documentation(info="<html>
  <p>
  Density of propylene antifreeze-water mixture at specified mass fraction
  and temperature, based on Melinder (2010).
  </p>
  <h4>References</h4>
  <p>
  Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
  Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
  IIR/IIF.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  May 2, 2018 by Massimo Cimmino:<br/>
  First implementation.
  This function is used by
  <a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
  IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
  </li>
  </ul>
  </html>"));

  end polynomialDensity;

  replaceable function polynomialDynamicViscosity
    "Evaluate dynamic viscosity of antifreeze-water mixture"
      extends Modelica.Icons.Function;

    input Modelica.SIunits.MassFraction w "Mass fraction of antifreeze";
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    output Modelica.SIunits.DynamicViscosity eta "Dynamic Viscosity of antifreeze-water mixture";
  algorithm
    eta := 1e-3*exp(polynomialProperty(
      w*100 "fixme: why multiplying by 100?",
      T,
      propertyCoefficients.wm*100,
      propertyCoefficients.Tm,
      propertyCoefficients.nw,
      propertyCoefficients.nT,
      propertyCoefficients.a_eta));

  annotation (
  Documentation(info="<html>
<p>
Dynamic viscosity of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
May 2, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end polynomialDynamicViscosity;

  replaceable function polynomialFusionTemperature
    "Evaluate temperature of fusion of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.SIunits.MassFraction w "Mass fraction of antifreeze";
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    output Modelica.SIunits.Temperature Tf "Temperature of fusion of antifreeze-water mixture";
  algorithm
    Tf := Modelica.SIunits.Conversions.from_degC(polynomialProperty(
      w*100 "fixme: why multiplying by 100?",
      T,
      propertyCoefficients.wm*100,
      propertyCoefficients.Tm,
      propertyCoefficients.nw,
      propertyCoefficients.nT,
      propertyCoefficients.a_Tf));

  annotation (
  Documentation(info="<html>
<p>
Fusion temperature of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
May 2, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end polynomialFusionTemperature;

  replaceable function polynomialProperty
    "Evaluates thermophysical property from 2-variable polynomial"
    extends Modelica.Icons.Function;

    input Real x "First independent variable";
    input Real y "Second independent variable";
    input Real xm "Reference value of x";
    input Real ym "Reference value of y";
    input Integer nx "Order of polynomial in x";
    input Integer ny[nx] "Order of polynomial in y";
    input Real a[sum(ny)] "Polynomial coefficients";

    output Real f "Value of thermophysical property";

  protected
    Real dx;
    Real dy;
    Integer n;
  algorithm

    dx := x - xm;
    dy := y - ym;

    f := 0;
    n := 0;
    for i in 0:nx-1 loop
      for j in 0:ny[i+1]-1 loop
        n := n + 1;
        f := f + a[n]*dx^i*dy^j;
      end for;
    end for;
  annotation (
  Documentation(info="<html>
<p>
Evaluates a thermophysical property of a mixture, based on correlations proposed
by Melinder (2010).
</p>
<p>
The polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
f = a<sub>1</sub> (x-xm)<sup>0</sup>(y-ym)<sup>0</sup>
+ a<sub>2</sub> (x-xm)<sup>0</sup>(y-ym)<sup>1</sup>
+ ... +
a<sub>ny[1]</sub> (x-xm)<sup>0</sup>(y-ym)<sup>ny[1]-1</sup>
+ ... +
a<sub>ny[1])+1</sub> (x-xm)<sup>1</sup>(y-ym)<sup>0</sup>
+ ... +
a<sub>ny[1]+ny[2]</sub> (x-xm)<sup>1</sup>(y-ym)<sup>ny[2]-1</sup>
+ ...
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used models in
<a href=\"modelica://IBPSA.Media.Antifreeze\">
IBPSA.Media.Antifreeze</a>.
</li>
</ul>
</html>"));
  end polynomialProperty;

  replaceable function polynomialSpecificHeatCapacityCp
    "Evaluate specific heat capacity of antifreeze-water mixture"
      extends Modelica.Icons.Function;

    input Modelica.SIunits.MassFraction w "Mass fraction of antifreeze";
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity of antifreeze-water mixture";
  algorithm
    cp := polynomialProperty(
      w*100 "fixme: why mulitplying by 100?",
      T,
      propertyCoefficients.wm*100,
      propertyCoefficients.Tm,
      propertyCoefficients.nw,
      propertyCoefficients.nT,
      propertyCoefficients.a_cp);

  annotation (
  Documentation(info="<html>
<p>
Specific heat capacity of antifreeze-water mixture at specified mass fraction
and temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end polynomialSpecificHeatCapacityCp;

  replaceable function polynomialThermalConductivity
    "Evaluate thermal conductivity of antifreeze-water mixture"
      extends Modelica.Icons.Function;

    input Modelica.SIunits.MassFraction w "Mass fraction of antifreeze";
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity of antifreeze-water mixture";
  algorithm
    lambda := polynomialProperty(
      w*100 "fixme: why multiplying by 100?",
      T,
      propertyCoefficients.wm*100,
      propertyCoefficients.Tm,
      propertyCoefficients.nw,
      propertyCoefficients.nT,
      propertyCoefficients.a_lambda);

  annotation (
  Documentation(info="<html>
<p>
Thermal conductivity of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://IBPSA.Media.Antifreeze.PropyleneGlycolWater\">
IBPSA.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end polynomialThermalConductivity;

annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models propylene glycol - water mixtures.
</p>
<p>
The mass density, specific heat capacity, thermal conductivity and viscosity
are assumed constant and evaluated at a set temperature and mass fraction of
propylene glycol within the mixture. The dependence of the four properties
are shown on the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterProperties.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The accuracy of the thermophysical properties is dependent on the temperature
variations encountered during simulations.
The figure below shows the relative error of the the four properties over a
<i>10</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>0.8</i> % for mass density, <i>1.5</i> %
for specific heat capacity, <i>3.2</i> % for thermal conductivity and <i>250</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError10degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The figure below shows the relative error of the the four properties over a
<i>20</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>1.6</i> % for mass density, <i>3.0</i> %
for specific heat capacity, <i>6.2</i> % for thermal conductivity and <i>950</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError20degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
The propylene glycol/water mixture is modeled as an incompressible liquid.
There are no phase changes. The medium is limited to temperatures below
<i>100</i> &deg;C and mass fractions below <i>0.60</i>.
As is the case for IBPSA.Media.Water, this medium package should not be used if
the simulation relies on the dynamic viscosity.
</p>
<h4>Typical use and important parameters</h4>
<p>
The temperature and mass fraction must be specified for the evaluation of the
constant thermophysical properties. A typical use of the package is (e.g. for
a temperature of <i>20</i> &deg;C and a mass fraction of <i>0.40</i>):
</p>
<p>
<code>Medium = IBPSA.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, massFraction=0.40)</code>
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PropyleneGlycolWater;
