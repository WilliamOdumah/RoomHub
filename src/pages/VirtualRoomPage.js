import React from 'react';
import { useNavigate } from 'react-router-dom';

const VirtualRoomPage = () => {

    const navigate = useNavigate();

    return (
        <div>
        <h1>Your Virtual Room</h1>
        {/* This is where room details will go */}
        <p>Virtual Room stuff here</p>
        {/* Navigating to home with hasRoom state true to simulate the backend knowing that the user now has a room */}
        <button onClick={() => navigate('/home',{ state: { hasRoom: true } })}>Back to Home</button>
        <button onClick={() => navigate('/')}>Log Out</button>
        </div>
    );
};

export default VirtualRoomPage;
