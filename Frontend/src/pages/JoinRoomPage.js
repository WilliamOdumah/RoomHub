import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import axios from 'axios'
import styles from '../styles/JoinRoomPage.module.css'; 

const JoinRoomPage = () => {
    const navigate = useNavigate();
    const location = useLocation();
    const email = location.state?.email;  // The current user's email
    const [ownerEmail, setOwnerEmail] = useState('');  // To capture the room owner's email
    const [error, setError] = useState('');

    // Function to handle input change
    const handleEmailChange = (event) => {
        setOwnerEmail(event.target.value);
    };

    // Function to handle the join request submission
    const handleSubmit = async (event) => {
        event.preventDefault();

        try {
            // Send a request to create a join-room notification
            await axios.post('https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/notification/join-room-request', {
                from: email,
                to: ownerEmail,
                type: 'join-request',
            });

            alert('Request sent to ' + ownerEmail);
            setError('');
            setOwnerEmail('');
        } catch (error) {
            if (error.response) {
                switch (error.response.status) {
                    case 404:
                        setError('Error: User not found.');
                        break;
                    case 400:
                        setError('Oops: Invalid request. Please check the details.');
                        break;
                    case 500:
                        setError('Error: There was an error on our end. Please try again later.');
                        break;
                    default:
                        setError('An unexpected error occurred.');
                }
            } else if (error.request) {
                // Request was made but no response was received
                setError('Error: No response from the server.');
            } else {
                // Something else caused an error
                setError('Error: Failed to send the request.');
            }
        }
    };

    return (
        <div className={styles.container}>
            <div className={styles.form}>
                <h1>Join Room</h1>
                <form onSubmit={handleSubmit}>
                    <label htmlFor="ownerEmail">Room Member's Email:</label>
                    <input 
                        type="email" 
                        name="ownerEmail" 
                        value={ownerEmail}
                        onChange={handleEmailChange}
                        required 
                    />
                    <button type="submit">Request to Join</button>
                </form>

                {/* Display error message if any */}
                {error && <p className={styles.error}>{error}</p>}

                <button className={styles.backButton} onClick={() => navigate('/home', { state: { email } })}>Back to Home</button>
            </div>
        </div>
    );
};

export default JoinRoomPage;
