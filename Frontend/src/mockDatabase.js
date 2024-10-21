// Simulating the User, Room, and Notification tables with arrays

export const users = [
    {
        userId: "odumahw@myumanitoba.ca",
        roomId: '101',
        notificationIds:[]
    },
    {
        userId: 'odumahwilliam@gmail.com',
        roomId: '102',
        notificationIds:[]
    },
    {
        userId: 'williamodumah@gmail.com',
        roomId: null,
        notificationIds:['201','202']
    },
    {
        userId: 'fake@gmail.com',
        roomId: null,
        notificationIds:[]
    },
];


export const rooms = [
    {
        roomId: '101',
        members:['odumahw@myumanitoba.ca'],
        name:'Room Alpha',
    },
    {
        roomId: '102',
        members:['odumahwilliam@gmail.com'],
        name:'Room Beta',
    },
];

export const notifications = [
    {
        id: "201",
        msg: "Hi, come join Room Alpha",
        status: "unread",
        from: "odumahw@myumanitoba.ca",
        to: "williamodumah@gmail.com",
        type: "invite",
        roomId: "101",
      },
      {
        id: "202",
        msg: "Join Room Beta!",
        status: "unread",
        from: "odumahwilliam@gmail.com",
        to: "williamodumah@gmail.com",
        type: "invite",
        roomId: "102",
      },
];