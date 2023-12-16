// Copyright (C) 2017 The Qt Company Ltd.
// BSD-3-Clause

#include <QtNetwork>
#include <QtCore>
#include <QDebug>

#include "sender.h"

Sender::Sender()
{

//! [0]
    udpSocket = new QUdpSocket(this);
//! [0]
    qDebug() << " testi" ;

}

void Sender::startSender()
{
    qDebug() << " testi2" ;
    startBroadcasting();
    broadcastDatagram();
}

void Sender::startBroadcasting()
{
    //timer.start(1000);
    qDebug() << "start broadcasting" ;
}

void Sender::broadcastDatagram()
{
    QByteArray datagram = "Broadcast message " + QByteArray::number(messageNo);
    udpSocket->writeDatagram(datagram, QHostAddress::Broadcast, 45454);
//! [1]
    ++messageNo;
}
