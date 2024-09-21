import React from 'react';
import { useNavigate } from 'react-router-dom';

const CreateRoomPage = () => {
    const navigate = useNavigate()

    const handleSubmit = () =>{
        // add room to users database
        alert('Your room has been created')
        navigate('/virtual-room')
    }

    return (
    <div>
        <h1>Create Room</h1>
        <form>
        <label>
            Room Name:
            <input type="text" name="roomName" />
        </label>
        <label>
            Invite Members (Emails):
            <input type="email" name="emails" />
        </label>
        <button type="submit" onClick={handleSubmit}>Create Room</button>
        </form>
        <button onClick={() => navigate('/home')}>Back to Home</button>
    </div>
    );
};

export default CreateRoomPage;
