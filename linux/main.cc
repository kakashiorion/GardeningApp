#include "plant_watering_application.h"

int main(int argc, char** argv) {
  g_autoptr(MyApplication) app = plant_watering_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
