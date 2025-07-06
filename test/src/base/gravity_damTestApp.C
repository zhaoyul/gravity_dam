//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "gravity_damTestApp.h"
#include "gravity_damApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
gravity_damTestApp::validParams()
{
  InputParameters params = gravity_damApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

gravity_damTestApp::gravity_damTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  gravity_damTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

gravity_damTestApp::~gravity_damTestApp() {}

void
gravity_damTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  gravity_damApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"gravity_damTestApp"});
    Registry::registerActionsTo(af, {"gravity_damTestApp"});
  }
}

void
gravity_damTestApp::registerApps()
{
  registerApp(gravity_damApp);
  registerApp(gravity_damTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
gravity_damTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  gravity_damTestApp::registerAll(f, af, s);
}
extern "C" void
gravity_damTestApp__registerApps()
{
  gravity_damTestApp::registerApps();
}
