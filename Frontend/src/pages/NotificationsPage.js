import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import styles from '../styles/NotificationsPage.module.css';

const NotificationsPage = () => {
    const location = useLocation();
    const email = location.state?.email;  // Get the email of the logged-in user
    const hasRoom = location.state?.hasRoom;
    const roomName = location.state?.roomName;
    const [notifications, setNotifications] = useState([]);
    const [error, setError] = useState('');
    const navigate = useNavigate();

    // Fetch the user's notifications when the component loads
    useEffect(() => {
        if (email) {
            const fetchNotifications = async () => {
                try {
                    console.log('trying to fetch notifications')
                    const response = await axios.get(
                      `https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/get-notification`
                    );

                    setNotifications(response.data.All_Notifications);
                } catch (error) {
                    setError('Error fetching notifications');
                }
            };
            fetchNotifications();
        }
    }, [email]);

    // Function to accept a room invite
    const handleAccept = async (notification) => {
        const from =notification.from;
        const id = notification.notification_id
        try {
            // Make the API call to add the new roommate
            const response = await axios.post(
                'https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/room/add-roommate',
                {
                    existing_roommate: email,
                    new_roommate: from,
                    room_nm: roomName,
                    notification_id: id,
                }
            );

            if (response.status === 200) {
                // If the request is successful, mark the notification as accepted
                const updatedNotifications = notifications.map((n) =>
                    n.notification_id === id ? { ...n, status: 'accepted' } : n
                );              
                setNotifications(updatedNotifications);
                alert('User successfully to your room!');
            } else {
                setError('Error: ' + response.data.message);
            }
        } catch (error) {
            console.log(error)
            if (error.response) {
                switch (error.response.status) {
                    case 404:
                        setError('Error: Room not found or user not found.');
                        break;
                    default:
                        setError('An unexpected error occurred.');
                }
            } else if (error.request) {
                setError('Error: No response from the server.');
            } else {
                setError('Error: Failed to send the request.');
            }
        }
    };


    return (
        <div className={styles.container}>
            <div className={styles.notificationsContainer}>
                <h1>Notifications</h1>

                {notifications.length > 0 ? (
                    <ul>
                        {notifications.map((notification) => (
                            <li 
                                key={notification.notification_id} 
                                className={notification.status === 'accepted' ? styles.accepted : ''}
                            >
                                {notification.msg} - {notification.status}
                                {notification.type === 'join-request' && notification.status !== 'accepted' && (
                                    <button onClick={() => handleAccept(notification)}>
                                        Accept
                                    </button>
                                )}
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No notifications available.</p>
                )}

                <button 
                    className={styles.backButton} 
                    onClick={() => navigate('/home', { state: { email, hasRoom } })}
                >
                    Back to Home
                </button>
            </div>
        </div>
    );
};

export default NotificationsPage;
