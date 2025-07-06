#include "gravity_damApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
gravity_damApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

gravity_damApp::gravity_damApp(const InputParameters & parameters) : MooseApp(parameters)
{
  gravity_damApp::registerAll(_factory, _action_factory, _syntax);
}

gravity_damApp::~gravity_damApp() {}

void
gravity_damApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<gravity_damApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"gravity_damApp"});
  Registry::registerActionsTo(af, {"gravity_damApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
gravity_damApp::registerApps()
{
  registerApp(gravity_damApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
gravity_damApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  gravity_damApp::registerAll(f, af, s);
}
extern "C" void
gravity_damApp__registerApps()
{
  gravity_damApp::registerApps();
}
