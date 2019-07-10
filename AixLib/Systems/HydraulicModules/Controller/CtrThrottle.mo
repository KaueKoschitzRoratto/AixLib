within AixLib.Systems.HydraulicModules.Controller;
block CtrThrottle "Controller for unmixed circuit with valve"
  //Boolean choice;

  parameter Boolean useExternalTset = false "If True, set temperature can be given externally";
  parameter Modelica.SIunits.Temperature TflowSet = 289.15 "Flow temperature set point of consumer";
  parameter Real k(min=0, unit="1") = 0.025 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=130
    "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td(min=0)= 4 "Time constant of Derivative block";
  parameter Real rpm_pump(min=0, unit="1") = 2000 "Rpm of the Pump";
  parameter Modelica.Blocks.Types.InitPID initType=.Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation(Dialog(group="PID"));
  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation(Dialog(group="PID"));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation(Dialog(group="PID"));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(group="PID"));
  Modelica.Blocks.Interfaces.RealInput Tact
                "Connector of measurement input signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput Tset if useExternalTset
    "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Sources.Constant constTflowSet(final k=TflowSet) if not useExternalTset annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  AixLib.Controls.Continuous.LimPID PID(
    final yMax=1,
    final yMin=0,
    final controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_start=y_start,
    final reverseAction=reverseAction)
            annotation (Placement(transformation(extent={{-16,-40},{4,-60}})));
  Modelica.Blocks.Sources.Constant constRpmPump(final k=rpm_pump) annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Logical.GreaterThreshold
                                        pumpSwitchOff(final threshold=0)
    annotation (Placement(transformation(extent={{16,32},{32,48}})));
equation

public
  BaseClasses.HydraulicBus  hydraulicBus
    annotation (Placement(transformation(extent={{66,-38},{120,16}})));
equation
    connect(PID.u_s, Tset) annotation (Line(
      points={{-18,-50},{-67.1,-50},{-67.1,-60},{-120,-60}},
      color={0,0,127},
      pattern=LinePattern.Dash));
    connect(constTflowSet.y, PID.u_s) annotation (Line(
      points={{-79,-20},{-68,-20},{-68,-50},{-18,-50}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(PID.y, hydraulicBus.valSet) annotation (Line(points={{5,-50},{48,-50},
          {48,-10.865},{93.135,-10.865}},
                                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(constRpmPump.y, hydraulicBus.pumpBus.rpm_Input) annotation (Line(points={{41,0},{48,0},{48,-10.865},{93.135,-10.865}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(PID.u_m, Tact)
    annotation (Line(points={{-6,-38},{-8,-38},{-8,60},{-120,60}}, color={0,0,127}));
  connect(PID.y,pumpSwitchOff. u)
    annotation (Line(points={{5,-50},{4,-50},{4,40},{14.4,40}}, color={0,0,127}));
  connect(pumpSwitchOff.y, hydraulicBus.pumpBus.onOff_Input) annotation (Line(points={{32.8,40},
          {93.135,40},{93.135,-10.865}},                     color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Text(
          extent={{-90,20},{56,-20}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="HCMI"),
          Rectangle(
          extent={{-90,80},{70,-80}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),Line(
          points={{10,80},{70,0},{30,-80}},
          color={95,95,95},
          thickness=0.5),
          Text(
          extent={{-90,20},{56,-20}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Control")}),
                                Diagram(coordinateSystem(preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>January 22, 2019, by Alexander K&uuml;mpel:<br/>First implementation.</li>
</ul>
</html>", info="<html>
<p>Simple controller for Throttle and ThrottlePump circuit. The controlled variable needs to be connected to Tact.</p>
<p>If the valve is fully closed, the pump will switch off.</p>
</html>"));
end CtrThrottle;
