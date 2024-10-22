import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { getUserById, addNotification} from '../mockApi';
import axios from 'axios'
import styles from '../styles/JoinRoomPage.module.css';   

const AddRoommatePage = () => {
    const [roommateEmail, setRoommateEmail] = useState('');
    const [error, setError] = useState('');
    const [available, setAvailable] = useState(false); // State to check if the feature is available
    const navigate = useNavigate();
    const location = useLocation();
    const email = location.state?.email;
    const hasRoom = location.state?.hasRoom;

    // Function to handle input change
    const handleEmailChange = (event) => {
        setRoommateEmail(event.target.value);  
    };

    // Function to send the GET request to check if the user has a room
    const checkRoommateRoom = async (roommateEmail) => {
        try {
            const response = await axios.get(`https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${roommateEmail}/get-room`);
            return response.data.room_name; // Return the room name if found
        } catch (error) {
            console.error('Error fetching room name:', error);
            return null; // Return null if there's an error or no room
        }
    };



    // Function to handle the request to add a roommate
    const handleSendRequest = async () => {
        const roommate = getUserById(roommateEmail);  // Check if the user exists

        if (!roommate) {
            // If the user doesn't exist, show an error
            setError('This user does not exist.');
            return;
        }

        try {
            const roomName = await checkRoommateRoom(roommateEmail); // Check if the roommate has a room

            if (roomName) {
                // If the user already has a room, show an error
                setError('This user is already part of another room.');
                return;
            }

            // If the user doesn't have a room, send a request (create a notification)
            await axios.post('https://api.example.com/notification/create-notification', {
                from: email,
                to: roommateEmail,
                type: 'invite',
            });

            alert('Request sent to ' + roommateEmail);
            setError('');  // Clear any previous errors
            setRoommateEmail('');  // Clear the input field
        } catch (error) {
            console.error('Error sending request:', error);
            setError('Error sending request.');
        }
    };

    // Render the page based on the availability of the feature
    if (!available) {
        return (
            <div className={styles.container}>
                <div className={styles.unavailable}>
                    <h1>Feature Currently Unavailable</h1>
                    <p>This feature is not available at the moment. You can ask the person to join your room instead.</p>
                    <button className={styles.backButton} onClick={() => navigate('/virtual-room', { state: { hasRoom, email } })}>Back to Room</button>
                </div>
            </div>
        );
    }

    return (
        <div className={styles.container}>
            <div className={styles.form}>
                <h1>Add New Roommate</h1>
                {/* Input field for roommate's email */}
                <label htmlFor="roommateEmail">Roommate's Email:</label>
                <input
                    type="email"
                    id="roommateEmail"
                    name="roommateEmail"
                    value={roommateEmail}
                    onChange={handleEmailChange}
                    required
                />
                
                <button onClick={handleSendRequest}>Send Request</button>

                {/* Display error message if any */}
                {error && <p className={styles.error}>{error}</p>}

                <button className={styles.backButton} onClick={() => navigate('/virtual-room', { state: { hasRoom, email } })}>Back to Room</button>
            </div>
        </div>
    );
};

export default AddRoommatePage;
