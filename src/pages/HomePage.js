import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';

const HomePage = () => {
  const location = useLocation();
  const hasRoom = location.state?.hasRoom; // Check if the user has a room
  const navigate = useNavigate()

  const handleFindRoomate = () =>{
    // currently unavailable
    alert('Feature currently unavailable')
  }

  // Conditionally render depending of whether the user has a room or not
  return (
    <div>
      <h1>Home Page</h1>

      {hasRoom ? (
        <>
          <button onClick={() => navigate('/virtual-room')}>Go to Your Room</button>
          <button onClick={handleFindRoomate}>Find Roomate Feature</button>
          <button onClick={() => navigate('/')}>Log Out</button>
        </>
      ) : (
        <>
          <button onClick={() => navigate('/create-room')}>Create Room</button>
          <button onClick={() => navigate('/join-room')}>Join Room</button>
          <button onClick={handleFindRoomate}>Find Roomate Feature</button>
          <button onClick={() => navigate('/')}>Log Out</button>
        </>
      )}
    </div>
  );
};

export default HomePage;
