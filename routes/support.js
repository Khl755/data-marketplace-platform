const express = require('express');
const router = express.Router();
const { createClient } = require('@supabase/supabase-js');
const { verifyToken } = require('./auth');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE
);

// Get Support Tickets
router.get('/', verifyToken, async (req, res) => {
  try {
    const { status, category } = req.query;
    let query = supabase
      .from('support_tickets')
      .select(`
        *,
        support_messages(*)
      `)
      .eq('user_id', req.user.id);

    if (status) query = query.eq('status', status);
    if (category) query = query.eq('category', category);

    const { data, error } = await query.order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create Support Ticket
router.post('/', verifyToken, async (req, res) => {
  try {
    const { subject, description, category, priority } = req.body;

    if (!subject || !description || !category) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const { data, error } = await supabase
      .from('support_tickets')
      .insert([
        {
          user_id: req.user.id,
          subject,
          description,
          category,
          priority: priority || 'normal',
          status: 'open'
        }
      ])
      .select();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      message: 'Support ticket created',
      ticket: data[0]
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add Message to Ticket
router.post('/:ticket_id/messages', verifyToken, async (req, res) => {
  try {
    const { message, attachment_url } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    const { data, error } = await supabase
      .from('support_messages')
      .insert([
        {
          ticket_id: req.params.ticket_id,
          user_id: req.user.id,
          message,
          attachment_url,
          is_admin_response: false
        }
      ])
      .select();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      message: 'Message added',
      ticket_message: data[0]
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Close Ticket
router.post('/:ticket_id/close', verifyToken, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('support_tickets')
      .update({
        status: 'closed',
        resolved_at: new Date()
      })
      .eq('id', req.params.ticket_id)
      .eq('user_id', req.user.id)
      .select();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      message: 'Ticket closed',
      ticket: data[0]
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
