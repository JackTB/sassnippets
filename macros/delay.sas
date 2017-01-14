/*
 * Specify the a time of day and delay processing by sleeping until that time. Time is in the
 * format HH:MM:SS with 24 hour time. For example: 07:15:00 is 7:15 am and 14:55:00 is 2:55 pm.
 *
 * The sleep function sleeps a specific number of seconds. This macro determines the
 * number of sections between now and the time you give.
 */
%macro delay(until);
	data _null_;
    t = time();
		sleepTime = "&until"t - t;
		* put t time12.3 ': Sleeping ' sleepTime 'seconds.';
    if (sleepTime > 0) then call sleep(sleepTime, 1);
	run;
%mend;
