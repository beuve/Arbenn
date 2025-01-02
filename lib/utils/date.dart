String monthFromInt(int m) {
  switch (m) {
    case DateTime.january:
      return "Janvier";
    case DateTime.february:
      return "Fevrier";
    case DateTime.march:
      return "Mars";
    case DateTime.april:
      return "Avril";
    case DateTime.may:
      return "Mai";
    case DateTime.june:
      return "June";
    case DateTime.july:
      return "Juillet";
    case DateTime.august:
      return "Aout";
    case DateTime.september:
      return "Septembre";
    case DateTime.october:
      return "Octobre";
    case DateTime.november:
      return "Novembre";
    default:
      return "Décembre";
  }
}

String weekDayFromInt(int d) {
  switch (d) {
    case DateTime.monday:
      return "Lundi";
    case DateTime.tuesday:
      return "Mardi";
    case DateTime.wednesday:
      return "Mercredi";
    case DateTime.thursday:
      return "Jeudi";
    case DateTime.friday:
      return "Vendredi";
    case DateTime.saturday:
      return "Samedi";
    default:
      return "Dimanche";
  }
}
