#ifndef FLUTTER_plant_watering_appLICATION_H_
#define FLUTTER_plant_watering_appLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, plant_watering_application, MY, APPLICATION,
                     GtkApplication)

/**
 * plant_watering_application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
MyApplication* plant_watering_application_new();

#endif  // FLUTTER_plant_watering_appLICATION_H_
