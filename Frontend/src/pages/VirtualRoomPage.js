import React, {useState, useEffect} from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { getRoomByUser, getRoomName } from '../mockApi';
import styles from '../styles/HomePage.module.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBell, faUser } from '@fortawesome/free-solid-svg-icons';
import Header from '../Header';
import axios from 'axios';

const VirtualRoomPage = () => {

    const navigate = useNavigate();
    const location = useLocation();
    const hasRoom = location.state?.hasRoom;
    const email = location.state?.email;
    const [roomName, setRoomName] = useState('')
    const [loading, setLoading] = useState(true);

    // const [showRoommates, setShowRoommates] = useState(false);  // State to toggle showing roommates
    
    // const toggleRoommates = () => {
    //     setShowRoommates(!showRoommates);
    // };

    useEffect(() => {
      const checkRoomStatus = async () => {
        try {
          const response = await axios.get(`https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/get-room`);
          if (response.status === 200 && response.data.room_name) {
            setRoomName(response.data.room_name);
            setLoading(false);
          }
        } catch (error) {
          console.error("Error fetching room data", error);
        }
      };
  
      if (email) {
        checkRoomStatus();
        
      }
    }, [email]);

    if (loading) {
      return <div>Loading...</div>;
    }

    return (
      <div className={styles.container}>
        <Header email={email} hasRoom={hasRoom} />
        <h2 className={styles.title}>{roomName}</h2>
        <div className={styles.cardGrid}>
          <div className={styles.card} onClick={() => navigate('/add-roommate-page', { state: { hasRoom, email } })}>
            <img src="find_roommate.png" alt="Room" className={styles.cardImage}/>
            <h2>Add new roomate</h2>
            <p>Add someone to your room</p>
            <button onClick={() => navigate('/add-roommate-page', { state: { hasRoom, email }})}>Add Roommate</button>
          </div>
        </div>

        {/* <button onClick={toggleRoommates} className={styles.action}>
          {showRoommates ? 'Hide Roommates' : 'Show Roommates'}
        </button>

        {showRoommates && (
          <div className={styles.roommatesList}>
             <h2>Roommates:</h2>
            <ul>
              {room.members.map((member, index) => (
                <li key={index}>{member}</li>
              ))}
            </ul>
          </div>
        )} */}
         
        <button className={styles.action} onClick={() => navigate('/home', { state: { hasRoom, email } })}>Back to Home</button>
      </div>
      );
};

export default VirtualRoomPage;

