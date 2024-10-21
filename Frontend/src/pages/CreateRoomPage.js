import React,{useState} from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import axios from 'axios'
import styles from '../styles/CreateRoomPage.module.css';

const CreateRoomPage = () => {
    const navigate = useNavigate()
    const location = useLocation();
    const hasRoom = location.state?.hasRoom; 
    const email = location.state?.email;
    const[name, setName] = useState('');
    const [error, setError] = useState('');

    // Function to handle input change
    const handleNameChange = (event) => {
        setName(event.target.value);
      };

      const handleSubmit = async () => {
        try {
          // Make a POST request to create a room
          const response = await axios.post('https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/room/create-room', {
            rm: name,
            id: email,
          });
    
          if (response.status === 200) {
            alert('Your room has been created');
            navigate('/virtual-room', { state: { email, hasRoom: true } }); // user now has a room
          } else {
            setError('Failed to create the room. Please try again.');
          }
        } catch (error) {
          setError('An error occurred while creating the room.');
          console.error('Room creation error:', error);
        }
      };

    return (
        <div className={styles.container}>
            <div className={styles.card}>
                <h1>Create Room</h1>
                <form>
                    <div className={styles.formGroup}>
                        <label htmlFor="name">Room Name:</label>
                        <input
                            type="text"
                            id="name"
                            name="name"
                            value={name}
                            onChange={handleNameChange}
                            required
                        />
                    </div>
                    <button type="button" onClick={handleSubmit}>Create Room</button>
                </form>
                {/* Display error message if any */}
                {error && <p className={styles.error}>{error}</p>}
                <button className={styles.backButton} onClick={() => navigate('/home', { state: { email, hasRoom: true } })}>Back to Home</button>
            </div>
        </div>
    );
};

export default CreateRoomPage;
