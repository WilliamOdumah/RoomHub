import { users, rooms, notifications } from './mockDatabase';

// User Methods ******************************************************

// Fetch a user by their ID
export const getUserById = (userId) => {
    console.log('getting user '+userId)
  return users.find(user => user.userId === userId);
};

// Add a new user when they sign up
export const addUser = (userId) => {
    const newUser = {
        userId,
        roomId: null,
        notificationIds: [],
    };
    users.push(newUser);
};



// Room Methods ******************************************************

// Fetch a room by its ID
export const getRoomById = (roomId) => {
  return rooms.find(room => room.roomId === roomId);
};

// Fetch the room by user ID (email)
export const getRoomByUser = (userId) => {
    const user = users.find(user => user.userId === userId);
    if (user && user.roomId) {
        return rooms.find(room => room.roomId === user.roomId);
    }
    return null;  // Return null if the user doesn't have a room
};

// Create new room
export const createRoom = (userId, name) => {
    const newRoom = {
        roomId: `${rooms.length + 1}`, // TEMP
        members: [userId],
        name,
    };
    rooms.push(newRoom);
    const user = getUserById(userId);
    if (user) {
        user.roomId = newRoom.roomId; 
    } else {
        console.error(`User ${userId} not found.`);
    }
};

export const getRoomName = (roomId) => {
    return rooms.find(room => room.roomId === roomId).name;
};

// Add a user to a room's member list
export const addMemberToRoom = (roomId, userId) => {
    const room = getRoomById(roomId);
    if (room && !room.members.includes(userId)) {
      room.members.push(userId);
      console.log(`User ${userId} added to room ${roomId}`);
    }
    const user = getUserById(userId);
    if (user) {
        user.roomId = room.roomId; 
    } else {
        console.error(`User ${userId} not found.`);
    }
};

// Fetch all members of a room
export const getRoomMembers = (roomId) => {
    const room = getRoomById(roomId);
    return room ? room.members : [];
};



// Notification Methods ******************************************************

// Fetch notifications for a user
export const getNotificationsByUserId = (userId) => {
  const user = getUserById(userId);
  if (!user) return [];
  
  return user.notificationIds.map(notificationId => 
    notifications.find(n => n.id === notificationId)
  );
};

// Add a new notification (simulated)
export const addNotification = (toUserId, msg, fromUserId, type, roomId) => {
  const newNotification = {
    id: `${notifications.length + 1}`,
    msg,
    status: "unread",
    from: fromUserId,
    to: toUserId,
    roomId,
    type,
  };
  notifications.push(newNotification);
  const user = getUserById(toUserId);
  if (user) {
    user.notificationIds.push(newNotification.id);
  }
};

// Mark a notification as read or accepted
export const markNotificationAsRead = (notificationId) => {
    const notification = notifications.find(n => n.id === notificationId);
    if (notification) {
        notification.status = 'accepted';
        console.log(`Notification ${notificationId} marked as accepted.`);
    }
};




  
  