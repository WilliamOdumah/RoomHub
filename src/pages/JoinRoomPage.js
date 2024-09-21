import React from 'react';
import { useNavigate } from 'react-router-dom';

const JoinRoomPage = () => {

    const navigate = useNavigate()
    
    const handleSubmit = () =>{
        // notification logic for request sent to owners email
        alert('Your request has been sent')
    }

    return (
        <div>
        <h1>Join Room</h1>
        <form>
            <label>
            Room Owner's Email:
            <input type="email" name="ownerEmail" />
            </label>
            <button type="submit" onClick={handleSubmit}>Request to Join</button>
        </form>
        <button onClick={() => navigate('/home')}>Back to Home</button>
        </div>
    );
};

export default JoinRoomPage;
