trigger TicketBookingTrigger on Ticket_booking__c (before insert, before update) {
    // Set to store unique user IDs from the incoming records
    Set<Id> userIds = new Set<Id>();

    // Collect user IDs from records in Trigger.new
    for (Ticket_booking__c ticket : Trigger.new) {
        if (ticket.User__c != null && ticket.Event_Date__c != null) {
            userIds.add(ticket.User__c);
        }
    }

    // Query existing bookings for the users in Trigger.new
    Map<Id, List<Date>> userToBookingDates = new Map<Id, List<Date>>();
    for (Ticket_booking__c existingBooking : [
        SELECT User__c, Event_Date__c 
        FROM Ticket_booking__c 
        WHERE User__c IN :userIds
    ]) {
        if (!userToBookingDates.containsKey(existingBooking.User__c)) {
            userToBookingDates.put(existingBooking.User__c, new List<Date>());
        }
        userToBookingDates.get(existingBooking.User__c).add(existingBooking.Event_Date__c);
    }

    // Loop through Trigger.new and check against the user's existing bookings
    for (Ticket_booking__c newTicket : Trigger.new) {
        if (newTicket.User__c != null && newTicket.Event_Date__c != null) {
            Date startOfWeek = newTicket.Event_Date__c.toStartOfWeek(); // Get Monday of the week
            Date endOfWeek = startOfWeek.addDays(6); // Get Sunday of the week

            // Retrieve the booking dates for the current user
            List<Date> bookingDates = userToBookingDates.get(newTicket.User__c);
            Boolean hasConflict = false;

            if (bookingDates != null) {
                for (Date bookingDate : bookingDates) {
                    if (bookingDate >= startOfWeek && bookingDate <= endOfWeek) {
                        hasConflict = true;
                        break;
                    }
                }
            }

            // If a conflict is found, add an error to prevent the booking
            if (hasConflict) {
                newTicket.addError('You can only book one ticket per week (Monday to Sunday).');
            } else {
                // Add the new booking date to the user's list for future checks within this transaction
                if (userToBookingDates.containsKey(newTicket.User__c)) {
                    userToBookingDates.get(newTicket.User__c).add(newTicket.Event_Date__c);
                } else {
                    userToBookingDates.put(newTicket.User__c, new List<Date>{newTicket.Event_Date__c});
                }
            }
        }
    }
}