grammar GitGraph

interface Common {
  accDescr?: string;
  accTitle?: string;
  title?: string;
}

fragment TitleAndAccessibilities:
  ((accDescr=ACC_DESCR | accTitle=ACC_TITLE | title=TITLE) EOL)+
;

fragment EOL returns string:
  NEWLINE+ | EOF
;

terminal NEWLINE: /\r?\n/;
terminal ACC_DESCR: /[\t ]*accDescr(?:[\t ]*:([^\n\r]*?(?=%%)|[^\n\r]*)|\s*{([^}]*)})/;
terminal ACC_TITLE: /[\t ]*accTitle[\t ]*:(?:[^\n\r]*?(?=%%)|[^\n\r]*)/;
terminal TITLE: /[\t ]*title(?:[\t ][^\n\r]*?(?=%%)|[\t ][^\n\r]*|)/;

hidden terminal WHITESPACE: /[\t ]+/;
hidden terminal YAML: /---[\t ]*\r?\n(?:[\S\s]*?\r?\n)?---(?:\r?\n|(?!\S))/;
hidden terminal DIRECTIVE: /[\t ]*%%{[\S\s]*?}%%(?:\r?\n|(?!\S))/;
hidden terminal SINGLE_LINE_COMMENT: /[\t ]*%%[^\n\r]*/;

entry Gantt:
  NEWLINE*
  'gantt'
  NEWLINE*
  (
    NEWLINE*
    (TitleAndAccessibilities |
    statements+=Statement |
     NEWLINE)*
  )
;

Statement
: Task
| GanttTitle
| DateFormat
| Excludes
| Includes
| Section
| Weekend
| Weekday
| AxisFormat
| Milestone
| TodayMarker
| TopAxis
| ClickStatement
;

DateFormat:
  'dateFormat' format=DATE_FORMAT EOL;

Task:
    'task' taskTxt=ID ':' taskData=STRING EOL;

GanttTitle:
    'title' title=STRING EOL;

Excludes:
    'excludes' excludes=STRING EOL;

Includes:
    'includes' includes=STRING EOL;

Section:
    'section' section=STRING EOL;

Weekend:
    'weekday' weekend=WEEKEND;

Weekday:
    'weekday' weekday=WEEKDAY;

AxisFormat:
    'axisFormat' format=STRING EOL;

Milestone:
    'milestone' milestone=STRING EOL;

TodayMarker:
    'todayMarker' marker=STRING EOL;

TopAxis:
    'topAxis' TopAxis='true' EOL;

ClickStatement:
    'click' click=STRING
    ('href' href=STRING | 'callbackName' callbackName=STRING | 'callbackArgs' callbackArgs=STRING)* EOL;




terminal WEEKDAY: 'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday' | 'saturday' | 'sunday';
terminal WEEKEND: 'friday' | 'saturday';
terminal DATE_FORMAT returns string: /[^#\n;]+/;
terminal ID returns string: /\w([-\./\w]*[-\w])?/;
terminal STRING: /"[^"]*"|'[^']*'/;