within AixLib.Utilities.Math.Functions;
function smoothLimit
  "Once continuously differentiable approximation to the limit function"
  input Real x "Variable";
  input Real l "Low limit";
  input Real u "Upper limit";
  input Real deltaX "Width of transition interval";
  output Real y "Result";

protected
  Real cor;
algorithm
  cor :=deltaX/10;
  y := AixLib.Utilities.Math.Functions.smoothMax(x,l+deltaX,cor);
  y := AixLib.Utilities.Math.Functions.smoothMin(y,u-deltaX,cor);
  annotation (smoothOrder = 1,
  Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <code>limit(.,.)</code> function.
The output is bounded to be in <i>[l, u]</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
Sept 1, 2010, by Michael Wetter:<br/>
Changed scaling to make sure that bounds are never violated.
</li>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothLimit;
